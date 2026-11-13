import 'package:flutter/material.dart';

import 'data/books.dart';
import 'features/book_details.dart';
import 'features/catalog.dart';
import 'features/commerce.dart';
import 'features/profile.dart';
import 'features/reader.dart';
import 'state/library_store.dart';
import 'ui/common.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class ReadApp extends StatelessWidget {
  const ReadApp({super.key, required this.store, this.initialRoute = '/home'});
  final LibraryStore store;
  final String initialRoute;
  @override
  Widget build(BuildContext context) => LibraryScope(
    store: store,
    child: MaterialApp(
      title: 'PostIt · Read',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: pink,
          surface: background,
          onSurface: Color(0xFFF0F0F4),
          secondary: muted,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        dividerTheme: const DividerThemeData(color: line, thickness: .7),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          hintStyle: const TextStyle(color: muted),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: raised,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      onGenerateRoute: (settings) {
        final book = settings.arguments is Book
            ? settings.arguments! as Book
            : books.first;
        final page = switch (settings.name) {
          '/home' => const HomePage(),
          '/find' => const FindPage(),
          '/find-grid' => const FindPage(grid: true),
          '/search' => SearchPage(
            query: settings.arguments is String
                ? settings.arguments! as String
                : '',
          ),
          '/category' => const CategoryPage(),
          '/success' => BookListPage(
            title: settings.arguments is String
                ? settings.arguments! as String
                : 'Success',
          ),
          '/book' => BookDetailsPage(book: book),
          '/library-added' => BookDetailsPage(book: book, overlay: 'library'),
          '/share' => BookDetailsPage(book: book, overlay: 'share'),
          '/comments' => const CommentsPage(),
          '/bookshelf' => const BookshelfPage(),
          '/mine' => const ProfilePage(),
          '/author' => const ProfilePage(author: true),
          '/writers' => const WritersPage(),
          '/settings' => const SettingsPage(),
          '/payment' => const PaymentPage(),
          '/cards' => const PaymentPage(showCards: true),
          '/buy' => BuyPage(book: book),
          '/daily' => const DailyPage(),
          '/reader' => ReaderPage(book: book),
          '/reader-highlight' => ReaderPage(book: book, highlight: true),
          '/purchases' => const BookListPage(
            title: 'My purchase',
            onlyPurchased: true,
          ),
          _ => const HomePage(),
        };
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => page,
        );
      },
    ),
  );
}
