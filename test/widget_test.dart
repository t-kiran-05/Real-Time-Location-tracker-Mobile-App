import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignemnt4/main.dart';

void main() {
  testWidgets('LocationApp mounts successfully test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LocationApp());

    // Verify MaterialApp widget renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

