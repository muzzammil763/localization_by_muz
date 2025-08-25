import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_example/main.dart';

void main() {
  testWidgets('Localization example app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads correctly
    expect(find.byType(MyApp), findsOneWidget);
    
    // Let the LocalizationProvider initialize
    await tester.pump();
    
    // Should find some basic text elements
    expect(find.byType(AppBar), findsOneWidget);
  });
}