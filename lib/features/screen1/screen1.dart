import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kturag/chat_screen.dart';

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
  String? selectedModel = "mistral"; // Default model

  @override
  void initState() {
    super.initState();
    _setupOllama();
  }

  Future<void> _setupOllama() async {
    bool isInstalled = await _checkOllamaInstalled();
    if (!isInstalled) {
      _showErrorDialog('Ollama is not installed. Please install it first.');
      setState(() => isStartingOllama = false);
      return;
    }

    bool isRunning = await _isOllamaRunning();
    if (!isRunning) {
      await _startOllama();
      await Future.delayed(
          const Duration(seconds: 3)); // Wait for Ollama to start
    }

    bool ollamaReady = await _isOllamaRunning();
    if (ollamaReady) {
      widget.onOllamaReady();
      await _fetchAvailableModels(); // Get the list of models
    } else {
      _showErrorDialog('Ollama failed to start.');
    }

    setState(() => isStartingOllama = false);
  }

  Future<bool> _checkOllamaInstalled() async {
    try {
      ProcessResult result = await Process.run('ollama', ['-v']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _isOllamaRunning() async {
    try {
      final result =
          await Process.run('curl', ['-s', 'http://localhost:11434/api/tags']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> _startOllama() async {
    try {
      if (Platform.isWindows) {
        await Process.start(
          'cmd',
          [
            '/c',
            'start',
            'cmd',
            '/k',
            'ollama serve'
          ], // Ensures Ollama stays running
          mode: ProcessStartMode.detached,
        );
      } else {
        await Process.start('ollama', ['serve'],
            mode: ProcessStartMode.detached);
      }
    } catch (e) {
      _showErrorDialog('Failed to start Ollama. Try starting it manually.');
    }
  }

  Future<void> _fetchAvailableModels() async {
    try {
      ProcessResult result =
          await Process.run('curl', ['-s', 'http://localhost:11434/api/tags']);
      if (result.exitCode == 0) {
        // Extract the model list (if available)
        setState(() => selectedModel =
            "mistral"); // You can update this logic to select a different model
      }
    } catch (e) {
      // Ignore error, fallback to default model
    }
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

  void _startChat() {
    if (!isStartingOllama) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatScreen(selectedModel: selectedModel ?? "mistral"),
        ),
      );
    } else {
      _showErrorDialog('Ollama is still starting. Please wait.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isStartingOllama
        ? const Center(child: CircularProgressIndicator())
        : Container(
            width: 280,
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'AI Chat App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Divider(
                  color:
                      widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  height: 1,
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: widget.isDarkMode ? Colors.white : Colors.blue,
                  ),
                  label: Text(
                    'New Chat',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.blue,
                    ),
                  ),
                  onPressed: _startChat,
                ),
              ],
            ),
          );
  }
}
