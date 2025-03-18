// routes.dart
import 'package:flutter/material.dart';
import 'package:kturag/features/screen1/widgets/chat_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const ChatScreen(),
  };
}
