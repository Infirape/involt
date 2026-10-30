import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:involt/main.dart';
import 'package:involt/core/data/database.dart';
import 'package:drift/native.dart';
import 'package:involt/core/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App should load and show SplashScreen', (WidgetTester tester) async {
    // 1. Setup in-memory database
    final db = AppDatabase.withExecutor(NativeDatabase.memory());
    
    // 2. Build our app
    await tester.pumpWidget(MyApp(db: db));

    // 3. Verify SplashScreen is present
    expect(find.byType(SplashScreen), findsOneWidget);
    
    // 4. Verify brand text is present
    expect(find.text('InVolt'), findsOneWidget);
    
    // Note: We don't pumpAndSettle here because SplashScreen has a 5s loop animation
    // and an async sync call that would fail/hang in this simple smoke test.
    // Unmount it and let its startup delay elapse so no timer is left pending.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 6));
  });
}
