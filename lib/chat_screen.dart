import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'message.dart';
import 'header.dart';
import 'side_panel.dart';
import 'chat_area.dart';

class ChatScreen extends StatefulWidget {
  final String selectedModel; // Store the selected model name

  const ChatScreen({super.key, required this.selectedModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });

    _textController.clear();

    // Show typing indicator
    setState(() {
      _messages.add(Message(text: "Thinking...", isUser: false));
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:11434/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": widget.selectedModel, // Use the selected model
          "prompt": text,
          "stream": false, // Change to true for streaming responses
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String responseText = data['response'] ?? "No response received.";

        setState(() {
          _messages.removeLast(); // Remove "Thinking..."
          _messages.add(Message(text: responseText, isUser: false));
        });
      } else {
        setState(() {
          _messages.removeLast();
          _messages.add(Message(text: "Error: Failed to get a response.", isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(Message(text: "Error connecting to Ollama.", isUser: false));
      });
    }

    // Auto-scroll to the latest message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              children: [
                const SidePanel(),
                Expanded(
                  child: ChatArea(
                    messages: _messages,
                    textController: _textController,
                    scrollController: _scrollController,
                    sendMessage: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
