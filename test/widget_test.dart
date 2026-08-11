import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cointale_project/main.dart';

void main() {
  testWidgets('CoinTale app loads welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CoinTaleApp(firebaseIsReady: false));
    await tester.pumpAndSettle();

    expect(find.textContaining('Every coin'), findsOneWidget);
    expect(find.text('Start Exploring'), findsOneWidget);

    final signInButton = find.byType(TextButton, skipOffstage: false);
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text("Don't have an account? Sign up"), findsOneWidget);
  });
}
