import 'package:flutter_test/flutter_test.dart';
import 'package:home_app/main.dart';

void main() {
  testWidgets('App smoke test — login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeApp());
    await tester.pumpAndSettle();

    // Verify login screen shows up
    expect(find.text('Hostel Management'), findsOneWidget);
  });
}
