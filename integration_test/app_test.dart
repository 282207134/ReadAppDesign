import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_app/app.dart';
import 'package:read_app/state/library_store.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('all Pixso views render and core journeys work', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = LibraryStore(await SharedPreferences.getInstance());
    await tester.pumpWidget(ReadApp(store: store));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      await binding.takeScreenshot(name);
    }

    Future<void> route(String name) async {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(name, (_) => false);
      await tester.pumpAndSettle();
    }

    await capture('01-home');
    await tester.drag(
      find.byKey(const Key('home-scroll')),
      const Offset(0, -610),
    );
    await tester.pumpAndSettle();
    await capture('02-home-long');
    const pages = [
      ('/success', '03-success'),
      ('/find', '04-find-focus'),
      ('/find-grid', '05-find-grid'),
      ('/search', '06-search'),
      ('/book', '07-book-details'),
      ('/library-added', '08-library-added'),
      ('/share', '09-book-share'),
      ('/comments', '10-comments'),
      ('/bookshelf', '11-bookshelf'),
      ('/mine', '12-mine'),
      ('/category', '13-category'),
      ('/author', '14-author'),
      ('/writers', '15-writers'),
      ('/settings', '16-settings'),
      ('/payment', '17-payment'),
      ('/cards', '18-payment-cards'),
      ('/buy', '19-buy'),
      ('/daily', '20-daily'),
      ('/reader', '21-reader'),
      ('/reader-highlight', '22-reader-highlight'),
    ];
    for (final (path, name) in pages) {
      await route(path);
      await capture(name);
    }
    // Search finds the requested book and opens its actual details.
    await route('/search');
    await tester.enterText(find.byKey(const Key('search-field')), 'Good Art');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Good Art'), findsNWidgets(2));
    expect(store.history.first, 'Good Art');
    await tester.tap(find.text('Good Art').last);
    await tester.pumpAndSettle();
    expect(find.text('Details'), findsOneWidget);
    await tester.tap(find.text('Like'));
    await tester.pumpAndSettle();
    expect(store.liked, contains('good-art'));
    await tester.tap(find.text('bookshelf'));
    await tester.pumpAndSettle();
    expect(find.text('Already added to\nyour library'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(store.shelf, contains('good-art'));
    await tester.tap(find.text('Buy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buy'));
    await tester.pumpAndSettle();
    expect(store.balance, 300);
    expect(store.purchased, contains('good-art'));
    await tester.tap(find.text('Start reading'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(store.chapter, 11);
    await route('/settings');
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(store.notice, isFalse);
    // Restore neutral data after test actions.
    await route('/home');
    expect(tester.takeException(), isNull);
  });
}
