import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen1/widgets/message.dart';

void main() {
  test('Message model should store text and user flag correctly', () {
    // Create a sample message
    const message = Message(text: "Hello, World!", isUser: true);

    // Verify the properties
    expect(message.text, "Hello, World!");
    expect(message.isUser, true);
  });

  test('Message model should support different values', () {
    const message = Message(text: "AI Response", isUser: false);

    expect(message.text, "AI Response");
    expect(message.isUser, false);
  });
}
