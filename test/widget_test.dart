import 'package:flutter_test/flutter_test.dart';

import 'package:cointale_project/screens/main_shell.dart';

void main() {
  testWidgets('CoinTale app loads welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CoinTaleApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Every coin'), findsOneWidget);
    expect(find.text('Start Exploring'), findsOneWidget);
  });
}
