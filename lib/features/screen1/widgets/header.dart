import 'package:flutter/material.dart';
import 'package:kturag/features/screen2/screen2.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer, // Theme-aware background
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KTURAG',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: theme.iconTheme.color), // Theme-aware icon
            onPressed: () {
              // Navigate to Screen2 when settings icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Screen2()),
              );
            },
          ),
        ],
      ),
    );
  }
}
