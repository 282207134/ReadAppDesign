import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/books.dart';

/// One small observable store; all personal changes are persisted locally.
class LibraryStore extends ChangeNotifier {
  LibraryStore(this.preferences) {
    shelf =
        preferences.getStringList('shelf')?.toSet() ??
        {'cannes', 'water', 'gorilla'};
    liked = preferences.getStringList('liked')?.toSet() ?? {};
    following =
        preferences.getStringList('following')?.toSet() ?? {'Justin Peter'};
    purchased = preferences.getStringList('purchased')?.toSet() ?? {};
    history =
        preferences.getStringList('history') ??
        [
          'Good Art',
          'Free sculpture',
          'Waterrl-G',
          'Sortir a Cannes',
          'All this has',
        ];
    balance = preferences.getDouble('balance') ?? 360;
    notice = preferences.getBool('notice') ?? true;
    fontSize = preferences.getDouble('fontSize') ?? 21;
    chapter = preferences.getInt('chapter') ?? 10;
    highlights = preferences.getStringList('highlights')?.toSet() ?? {};
    for (final value in preferences.getStringList('reviews') ?? <String>[]) {
      final map = jsonDecode(value) as Map<String, dynamic>;
      reviews.add(Review('Marlene Anna', 'profile', map['text'] as String));
    }
  }
  final SharedPreferences preferences;
  late Set<String> shelf, liked, following, purchased, highlights;
  late List<String> history;
  final List<Review> reviews = [];
  late double balance, fontSize;
  late int chapter;
  late bool notice;
  Future<void> save() async {
    notifyListeners();
    await Future.wait([
      preferences.setStringList('shelf', shelf.toList()),
      preferences.setStringList('liked', liked.toList()),
      preferences.setStringList('following', following.toList()),
      preferences.setStringList('purchased', purchased.toList()),
      preferences.setStringList('history', history),
      preferences.setDouble('balance', balance),
      preferences.setBool('notice', notice),
      preferences.setDouble('fontSize', fontSize),
      preferences.setInt('chapter', chapter),
      preferences.setStringList('highlights', highlights.toList()),
      preferences.setStringList(
        'reviews',
        reviews.map((r) => jsonEncode({'text': r.text})).toList(),
      ),
    ]);
  }

  void toggleLike(String id) {
    liked.contains(id) ? liked.remove(id) : liked.add(id);
    save();
  }

  void follow(String name) {
    following.contains(name) ? following.remove(name) : following.add(name);
    save();
  }

  void addBook(String id) {
    shelf.add(id);
    save();
  }

  void search(String value) {
    if (value.trim().isEmpty) return;
    history.remove(value.trim());
    history.insert(0, value.trim());
    history = history.take(10).toList();
    save();
  }

  bool buy(Book book) {
    if (purchased.contains(book.id)) return true;
    if (balance < book.price) return false;
    balance -= book.price;
    purchased.add(book.id);
    shelf.add(book.id);
    save();
    return true;
  }
}
