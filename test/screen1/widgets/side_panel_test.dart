import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kturag/features/screen1/widgets/side_panel.dart';

void main() {
  testWidgets('SidePanel widget should render correctly', (WidgetTester tester) async {
    // Build the SidePanel widget inside a MaterialApp
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SidePanel())));

    // Verify that the Placeholder widget is present in the SidePanel
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
