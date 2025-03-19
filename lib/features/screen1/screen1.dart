import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:kturag/features/screen1/widgets/chat_screen.dart';
import 'package:kturag/features/screen2/screen2.dart';

class Screen1 extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;
  final Function() onOllamaReady;

  const Screen1({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.onOllamaReady,
  });

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool isStartingOllama = true;
  String? selectedModel = "lama3.2:latest"; // Default model
  final Logger log = Logger(); // Initialize logger

  @override
  void initState() {
    super.initState();
    _setupOllama();
  }

  Future<void> _setupOllama() async {
    log.i("Checking if Ollama is installed...");

    bool isInstalled = await _checkOllamaInstalled();
    if (!isInstalled) {
      log.e("Ollama is not installed.");
      _showErrorDialog('Ollama is not installed. Please install it first.');
      setState(() => isStartingOllama = false);
      return;
    }

    log.i("Checking if Ollama is running...");
    bool isRunning = await _isOllamaRunning();
    if (!isRunning) {
      log.w("Ollama is not running. Attempting to start...");
      await _startOllama();
      await Future.delayed(const Duration(seconds: 5)); // Wait for Ollama to start
    }

    bool ollamaReady = await _isOllamaRunning();
    if (ollamaReady) {
      log.i("Ollama is running.");
      widget.onOllamaReady();
      await _fetchAvailableModels();
    } else {
      log.e("Ollama failed to start.");
      _showErrorDialog('Ollama failed to start.');
    }

    setState(() => isStartingOllama = false);
  }

  Future<bool> _checkOllamaInstalled() async {
    try {
      ProcessResult result = await Process.run('ollama', ['-v']);
      return result.exitCode == 0;
    } catch (e) {
      log.e("Failed to check Ollama installation: $e");
      return false;
    }
  }

  Future<bool> _isOllamaRunning() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:11434/api/tags'))
          .timeout(const Duration(seconds: 3));

      return response.statusCode == 200;
    } catch (e) {
      log.w("Ollama is not responding: $e");
      return false;
    }
  }

  Future<void> _startOllama() async {
    try {
      if (Platform.isWindows) {
        await Process.start(
          'cmd',
          ['/c', 'start', '/b', 'ollama serve'], // Run in the background
          mode: ProcessStartMode.detached,
        );
      } else {
        await Process.start('ollama', ['serve'], mode: ProcessStartMode.detached);
      }
      log.i("Ollama started successfully.");
    } catch (e) {
      log.e("Failed to start Ollama: $e");
      _showErrorDialog('Failed to start Ollama. Try starting it manually.');
    }
  }

  Future<void> _fetchAvailableModels() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:11434/api/tags'))
          .timeout(const Duration(seconds: 3));

      log.d('Ollama API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null || !data.containsKey('models')) {
          log.e('Error: API response does not contain "models" key.');
          _setDefaultModel();
          return;
        }

        if (data['models'].isEmpty) {
          log.w('No models available. Using default: deepseek-r1:latest');
          _setDefaultModel();
          return;
        }

        setState(() {
          selectedModel = data['models'][0]['name']; // Ensure key exists
        });

        log.i('Selected Model: $selectedModel');
      } else {
        log.e('Failed to fetch models, Status Code: ${response.statusCode}');
        _setDefaultModel();
      }
    } catch (e) {
      log.e('Error fetching models: $e');
      _setDefaultModel();
    }
  }

  void _setDefaultModel() {
    setState(() {
      selectedModel = "deepseek-r1:latest";
    });
    log.i("Using default model: deepseek-r1:latest");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startChat() async {
    if (isStartingOllama) {
      _showErrorDialog('Ollama is still starting. Please wait.');
      return;
    }

    final selectedModelFromScreen2 = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Screen2()),
    );

    if (selectedModelFromScreen2 != null && selectedModelFromScreen2 is String) {
      setState(() {
        selectedModel = selectedModelFromScreen2;
      });
    }

    log.i("Starting chat with model: $selectedModel");

    if (selectedModel != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } else {
      _showErrorDialog('No model selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return isStartingOllama
        ? const Center(child: CircularProgressIndicator())
        : Container(
            width: 280,
            color: theme.colorScheme.surface, // Adapts to theme mode
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'AI Chat App',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface, // Adapts text color
                    ),
                  ),
                ),
                Divider(
                  color: theme.colorScheme.outlineVariant, // Matches theme outline
                  height: 1,
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: theme.colorScheme.primary, // Uses primary theme color
                  ),
                  label: Text(
                    'New Chat',
                    style: TextStyle(
                      color: theme.colorScheme.primary, // Themed text color
                    ),
                  ),
                  onPressed: _startChat,
                ),
              ],
            ),
          );
  }
}
