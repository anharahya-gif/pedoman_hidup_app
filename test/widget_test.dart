import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedoman_hidup_app/app.dart';
import 'package:pedoman_hidup_app/shared/providers.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const PedomanHidupApp(),
      ),
    );

    expect(find.byType(PedomanHidupApp), findsOneWidget);
  });
}
