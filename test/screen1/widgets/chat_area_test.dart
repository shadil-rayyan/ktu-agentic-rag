import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen1/widgets/chat_area.dart';
import 'package:kturag/features/screen1/widgets/message.dart';
void main() {
  group('ChatArea Widget Tests', () {
    late TextEditingController textController;
    late ScrollController scrollController;
    late List<Message> messages;
    late Function(String) mockSendMessage;

    setUp(() {
      textController = TextEditingController();
      scrollController = ScrollController();
      messages = [
        Message(text: 'Hello', isUser: true),
        Message(text: 'Hi there!', isUser: false),
      ];
      mockSendMessage = (String message) {
        messages.add(Message(text: message, isUser: true));
      };
    });

    testWidgets('renders chat messages correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatArea(
            messages: messages,
            textController: textController,
            scrollController: scrollController,
            sendMessage: mockSendMessage,
          ),
        ),
      ));

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi there!'), findsOneWidget);
    });

    testWidgets('sends a message when send button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatArea(
            messages: messages,
            textController: textController,
            scrollController: scrollController,
            sendMessage: mockSendMessage,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'New message');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(messages.last.text, 'New message');
    });

    testWidgets('sends a message when Enter is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatArea(
            messages: messages,
            textController: textController,
            scrollController: scrollController,
            sendMessage: mockSendMessage,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Another message');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(messages.last.text, 'Another message');
    });
  });
}