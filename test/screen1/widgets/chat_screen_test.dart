import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen1/widgets/side_panel.dart';
import 'package:kturag/features/screen1/widgets/header.dart';
import 'package:kturag/features/screen1/widgets/chat_area.dart';
import 'package:kturag/features/screen1/widgets/chat_screen.dart';


void main() {
  testWidgets('ChatScreen UI Test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: ChatScreen(),
      ),
    );

    // Check if Header exists
    expect(find.byType(Header), findsOneWidget);

    // Check if SidePanel exists
    expect(find.byType(SidePanel), findsOneWidget);

    // Check if ChatArea exists
    expect(find.byType(ChatArea), findsOneWidget);

    // Check if text input field exists
    expect(find.byType(TextField), findsOneWidget);

    // Check if send button exists
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}
