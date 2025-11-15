import 'package:flutter_test/flutter_test.dart';

import 'package:tadreeb/app/app.dart';

void main() {
  testWidgets('Login view renders expected content', (tester) async {
    await tester.pumpWidget(const TadreebApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });
}
