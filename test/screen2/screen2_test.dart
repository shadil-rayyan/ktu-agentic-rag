import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen2/screen2.dart';
void main() {
  testWidgets('Screen2 UI Test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Screen2(),
      ),
    );

    // Check if AppBar title exists
    expect(find.text('Select Ollama Model'), findsOneWidget);

    // Check if loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the screen to load (simulate end of async calls)
    await tester.pumpAndSettle();

    // Check if Installed Models text appears
    expect(find.text('Installed Models:'), findsOneWidget);

    // Check if Install New Model section is present
    expect(find.text('Install New Model:'), findsOneWidget);

    // Check if dropdowns exist
    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));

    // Check if "Save & Back" and "Install Model" buttons exist
    expect(find.widgetWithText(ElevatedButton, 'Save & Back'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Install Model'), findsOneWidget);
  });
}
