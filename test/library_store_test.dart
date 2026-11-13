import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_app/data/books.dart';
import 'package:read_app/state/library_store.dart';

void main() {
  Future<LibraryStore> create() async {
    SharedPreferences.setMockInitialValues({});
    return LibraryStore(await SharedPreferences.getInstance());
  }

  test('purchase debits once and persists ownership', () async {
    final store = await create();
    expect(store.buy(books[0]), isTrue);
    expect(store.balance, 300);
    expect(store.shelf, contains('cannes'));
    expect(store.buy(books[0]), isTrue);
    expect(store.balance, 300);
    await store.save();
    final restored = LibraryStore(store.preferences);
    expect(restored.purchased, contains('cannes'));
    expect(restored.balance, 300);
  });
  test('insufficient funds leave wallet and library unchanged', () async {
    final store = await create();
    store.balance = 20;
    expect(store.buy(books[1]), isFalse);
    expect(store.balance, 20);
    expect(store.purchased, isEmpty);
    expect(store.shelf.contains('children'), isFalse);
  });
  test(
    'history is deduplicated and personal reading state survives reload',
    () async {
      final store = await create();
      store.search('Good Art');
      store.search('Good Art');
      store.toggleLike('children');
      store.follow('Yvette');
      store.chapter = 11;
      store.highlights.add('cannes:11');
      await store.save();
      final restored = LibraryStore(store.preferences);
      expect(restored.history.where((s) => s == 'Good Art').length, 1);
      expect(restored.liked, contains('children'));
      expect(restored.following, contains('Yvette'));
      expect(restored.chapter, 11);
      expect(restored.highlights, contains('cannes:11'));
    },
  );
}
