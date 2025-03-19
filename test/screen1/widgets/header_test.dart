import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen1/widgets/header.dart';
import 'package:kturag/features/screen2/screen2.dart';

void main() {
  testWidgets('Header UI Test', (WidgetTester tester) async {
    // Build the widget inside a MaterialApp (for navigation to work)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Header()),
      ),
    );

    // Check if the header text exists
    expect(find.text('KTURAG'), findsOneWidget);

    // Check if the settings icon button exists
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Navigates to Screen2 when settings button is clicked',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Header()),
        routes: {
          '/screen2': (context) => const Screen2()
        }, // Define route for navigation
      ),
    );

    // Tap on the settings button
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Check if Screen2 is displayed
    expect(find.byType(Screen2), findsOneWidget);
  });
}
