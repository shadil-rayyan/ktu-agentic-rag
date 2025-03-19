import 'package:flutter/material.dart';

class Screen1UI extends StatelessWidget {
  final bool isStartingOllama;
  final VoidCallback onStartChat;

  const Screen1UI({
    super.key,
    required this.isStartingOllama,
    required this.onStartChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280, // Sidebar width
      color: theme.colorScheme.surface, // Theme-aware background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // **Header**
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'AI Chat App',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface, // Themed text color
              ),
            ),
          ),

          // **Divider**
          Divider(
            color: theme.colorScheme.outlineVariant, // Matches theme outline
            height: 1,
          ),

          const SizedBox(height: 16),

          // **New Chat Button**
          Center(
            child: TextButton.icon(
              icon: Icon(
                Icons.add,
                color: theme.colorScheme.primary, // Primary color
              ),
              label: Text(
                'New Chat',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: isStartingOllama ? null : onStartChat, // Disable if Ollama is starting
            ),
          ),

          const Spacer(),

          // **Ollama Status**
          if (isStartingOllama)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()), // Show loading
            ),
        ],
      ),
    );
  }
}
