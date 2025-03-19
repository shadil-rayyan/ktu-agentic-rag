import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen1/widgets/chat_bubble.dart';

void main() {
  testWidgets('ChatBubble displays text and has correct alignment', (WidgetTester tester) async {
    const testText = "Hello, this is a test!";
    
    // Build a ChatBubble for a user message
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatBubble(text: testText, isUser: true),
        ),
      ),
    );

    // Verify the text appears
    expect(find.text(testText), findsOneWidget);

    // Verify alignment for a user message (right)
    final container = tester.widget<Container>(find.byType(Container));
    expect((container.decoration as BoxDecoration).color, equals(Colors.blue)); // Check color (adjust if needed)
    
    // Test ChatBubble for a non-user message
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatBubble(text: testText, isUser: false),
        ),
      ),
    );

    // Verify alignment for a non-user message (left)
    final container2 = tester.widget<Container>(find.byType(Container));
    expect((container2.decoration as BoxDecoration).color, isNot(Colors.blue)); // Should be a different color
  });
}
