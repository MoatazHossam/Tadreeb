import 'package:flutter_test/flutter_test.dart';

import 'package:tadreeb/app/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(const MyApp());


    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });
}
