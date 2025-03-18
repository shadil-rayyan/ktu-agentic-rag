// app.dart
import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes.dart';
// import 'package:kturag/features/screen1/widgets/chat_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
    );
  }
}
