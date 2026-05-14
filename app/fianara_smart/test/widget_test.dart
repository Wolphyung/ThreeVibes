import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test basique', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Fianara Smart City'),
          ),
        ),
      ),
    );

    expect(find.text('Fianara Smart City'), findsOneWidget);
  });
}
