import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<String> installedModels = [];
  List<String> availableModels = ['mistral', 'gemma', 'llama3', 'phi3']; // Default models
  String? selectedModel;
  bool isLoading = true;
  bool isDownloading = false;
  bool installingOllama = false;
  bool isOllamaInstalled = false;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    setupOllama();
  }

  /// Check if Ollama is installed; if not, install it
  Future<void> setupOllama() async {
    setState(() => isLoading = true);

    isOllamaInstalled = await checkOllamaInstalled();
    if (!isOllamaInstalled) {
      await installOllama();
    } else {
      await fetchInstalledModels();
    }

    setState(() => isLoading = false);
  }

  /// Check if Ollama is installed
  Future<bool> checkOllamaInstalled() async {
    try {
      var result = await Process.run('ollama', ['--version']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Install Ollama
  Future<void> installOllama() async {
    setState(() => installingOllama = true);
    showProgressDialog("Installing Ollama...");

    try {
      if (Platform.isWindows) {
        await Process.run('winget', ['install', '--id=Ollama.Ollama']);
      } else if (Platform.isMacOS) {
        await Process.run('brew', ['install', 'ollama']);
      } else if (Platform.isLinux) {
        await Process.run('bash', ['-c', 'curl -fsSL https://ollama.ai/install.sh | bash']);
      }

      Navigator.pop(context);
      showSuccessDialog("Ollama installed successfully!");
      isOllamaInstalled = true;
      await fetchInstalledModels();
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog("Failed to install Ollama. Please install it manually.");
    }

    setState(() => installingOllama = false);
  }

  /// Fetch installed models
  Future<void> fetchInstalledModels() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:11434/api/tags'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> models = List<String>.from(data['models'].map((model) => model['name']));

        setState(() {
          installedModels = models;
          availableModels.removeWhere((model) => models.contains(model)); // Remove installed ones
          selectedModel = models.isNotEmpty ? models.first : null;
        });
      } else {
        throw Exception('Failed to load models');
      }
    } catch (e) {
      setState(() => installedModels = []);
      showErrorDialog('Failed to connect to Ollama. Make sure it is running.');
    }
  }

  /// Download a model
  Future<void> downloadModel(String model) async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    showProgressDialog("Downloading $model...");

    try {
      var response = await http.post(
        Uri.parse('http://localhost:11434/api/pull'),
        body: jsonEncode({'name': model}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        showSuccessDialog('Model $model downloaded successfully!');
        fetchInstalledModels();
      } else {
        Navigator.pop(context);
        showErrorDialog('Failed to download model. Try again.');
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog('Error downloading model.');
    }

    setState(() {
      isDownloading = false;
      downloadProgress = 0.0;
    });
  }

  /// Show progress dialog
  void showProgressDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: downloadProgress),
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Ollama Model'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Installed Models:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Dropdown for installed models
                  if (installedModels.isNotEmpty)
                    DropdownButtonFormField<String>(
                      value: selectedModel,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: installedModels.map((model) {
                        return DropdownMenuItem(
                          value: model,
                          child: Text(model),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedModel = newValue;
                        });
                      },
                    )
                  else
                    const Text('No models installed.'),

                  const SizedBox(height: 20),

                  // Save button
                  ElevatedButton(
                    onPressed: selectedModel != null
                        ? () => Navigator.pop(context, selectedModel)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: const Text('Save & Back', style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 20),

                  // Available models section
                  const Text(
                    'Available Models for Installation:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (availableModels.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableModels.map((model) {
                        return ElevatedButton(
                          onPressed: () => downloadModel(model),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            'Download $model',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Text('All available models are installed.'),
                ],
              ),
      ),
    );
  }
}
