import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_app/app.dart';
import 'package:read_app/state/library_store.dart';

void main() {
  testWidgets('all page layouts fit the 375px design viewport', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ReadApp(store: LibraryStore(await SharedPreferences.getInstance())),
    );
    await tester.pumpAndSettle();
    const routes = [
      '/home',
      '/find',
      '/find-grid',
      '/search',
      '/category',
      '/success',
      '/book',
      '/library-added',
      '/share',
      '/comments',
      '/bookshelf',
      '/mine',
      '/author',
      '/writers',
      '/settings',
      '/payment',
      '/cards',
      '/buy',
      '/daily',
      '/reader',
      '/reader-highlight',
    ];
    for (final path in routes) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(path, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: path);
    }
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/comments',
      (_) => false,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Write review'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('review-field')),
      'A memorable reading journey.',
    );
    await tester.tap(find.text('Publish'));
    await tester.pumpAndSettle();
    expect(find.text('A memorable reading journey.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
