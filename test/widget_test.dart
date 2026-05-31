import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_catalog_app/main.dart';
import 'package:product_catalog_app/injection_container.dart' as di;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await di.sl.reset();
    await di.init();
  });

  testWidgets('Smoke test for Login page layout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we are on the login page.
    expect(find.text('Welcome to Catalog'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
