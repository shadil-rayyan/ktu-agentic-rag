import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'message.dart';
import 'header.dart';
import 'side_panel.dart';
import 'chat_area.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _messages.add(Message(text: "Thinking...", isUser: false));
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:11434/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'deepseek-r1:latest', // 🔥 Always using deepseek-r1:latest
          'prompt': text,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final String responseText = jsonResponse['response'] ?? "No response received.";

        setState(() {
          _messages.removeLast(); // Remove "Thinking..."
          _messages.add(Message(text: responseText, isUser: false));
        });
      } else {
        _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      _handleError(500, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _handleError(int statusCode, String message) {
    print("Error ($statusCode): $message");
    setState(() {
      _messages.removeLast();
      _messages.add(Message(text: "Error: $statusCode\n$message", isUser: false));
    });
  }

  void _scrollToBottom() {
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Theme-aware background
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              children: [
                const SidePanel(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface, // Theme-aware chat area background
                    ),
                    child: ChatArea(
                      messages: _messages,
                      textController: _textController,
                      scrollController: _scrollController,
                      sendMessage: _sendMessage,
                    ),
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
