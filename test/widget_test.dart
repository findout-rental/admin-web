// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:admin_web/app/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Initialize GetStorage for testing
    await GetStorage.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify that the login page is shown
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
