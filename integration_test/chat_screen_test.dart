import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kturag/features/screen1/widgets/chat_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("ChatScreen should send a message and receive a response", (WidgetTester tester) async {
    // Pump the ChatScreen widget
    await tester.pumpWidget(
      const MaterialApp(home: ChatScreen()), // Wrap in MaterialApp for themes
    );

    // Wait for the UI to settle
    await tester.pumpAndSettle();

    // Find the text input field
    final Finder textField = find.byType(TextField);

    // Enter text into the input field
    await tester.enterText(textField, "Hello AI");
    await tester.pump();

    // Find the send button and tap it (replace with actual button Finder if needed)
    final Finder sendButton = find.byIcon(Icons.send);
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    // Verify the sent message appears in chat
    expect(find.text("Hello AI"), findsOneWidget);

    // Simulate waiting for a response
    await tester.pump(const Duration(seconds: 2));

    // Verify that a response appears (mocked response)
    expect(find.textContaining("Thinking..."), findsNothing); // Thinking text should disappear
    expect(find.textContaining("Error"), findsNothing); // Should not show an error

    // The AI response is dynamic, so we check for the presence of at least one response
    expect(find.byType(ListTile), findsWidgets);
  });
}
