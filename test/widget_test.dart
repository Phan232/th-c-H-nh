import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab8/main.dart';

void main() {
  testWidgets('shows the posts list loading state', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('API Posts List'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
