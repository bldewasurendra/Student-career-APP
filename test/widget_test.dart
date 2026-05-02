import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UniPathApp());

    // Verify that the app title or some home content is present.
    expect(find.text('Find Your Path'), findsOneWidget);
  });
}
