import 'package:flutter/material.dart';
import 'message.dart';
import 'chat_bubble.dart';

class ChatArea extends StatelessWidget {
  final List<Message> messages;
  final TextEditingController textController;
  final ScrollController scrollController;
  final Function(String) sendMessage;

  const ChatArea({
    super.key,
    required this.messages,
    required this.textController,
    required this.scrollController,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: messages.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final message = messages[index];
              return ChatBubble(
                text: message.text,
                isUser: message.isUser,
              );
            },
          ),
        ),
        _buildInputField(context),
      ],
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => sendMessage(textController.text),
            ),
          ),
        ],
      ),
    );
  }
}