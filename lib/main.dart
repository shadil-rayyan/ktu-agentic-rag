// In your main.dart or wherever your main app is
import 'package:flutter/material.dart';
import 'features/screen1/screen1.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat App',
      theme: _isDarkMode 
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        body: Row(
          children: [
            Screen1(
              isDarkMode: _isDarkMode,
              onDarkModeChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            // Add your main chat content area here
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}