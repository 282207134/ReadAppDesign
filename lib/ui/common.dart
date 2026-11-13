import 'package:flutter/material.dart';

import '../data/books.dart';
import '../state/library_store.dart';

const background = Color(0xFF21272E);
const panel = Color(0xFF292C34);
const raised = Color(0xFF373A49);
const pink = Color(0xFFFA6097);
const muted = Color(0xFF9296AD);
const line = Color(0xFF363B49);

class LibraryScope extends InheritedNotifier<LibraryStore> {
  const LibraryScope({
    super.key,
    required LibraryStore store,
    required super.child,
  }) : super(notifier: store);
  static LibraryStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LibraryScope>()!.notifier!;
}

void open(BuildContext context, String route, {Object? arguments}) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);

void message(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.bottom,
    this.back = true,
    this.tab,
    this.leading,
  });
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? bottom;
  final Widget? leading;
  final bool back;
  final int? tab;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      centerTitle: true,
      automaticallyImplyLeading: back,
      leading: back
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : leading,
      actions: actions,
    ),
    body: child,
    bottomNavigationBar:
        bottom ?? (tab == null ? null : BottomTabs(index: tab!)),
  );
}

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      height: 65,
      decoration: const BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: Color(0xFF282E36))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          4,
          (i) => IconButton(
            tooltip: ['Today', 'Find', 'Bookshelf', 'Mine'][i],
            onPressed: () {
              if (i != index) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  ['/home', '/find', '/bookshelf', '/mine'][i],
                  (_) => false,
                );
              }
            },
            icon: Icon(
              [
                Icons.home_outlined,
                Icons.explore_outlined,
                Icons.menu_book_outlined,
                Icons.person_outline,
              ][i],
              size: 29,
              color: i == index ? pink : muted,
            ),
          ),
        ),
      ),
    ),
  );
}

class Cover extends StatelessWidget {
  const Cover(this.book, {super.key, this.width = 96, this.height, this.onTap});
  final Book book;
  final double width;
  final double? height;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Open ${book.title}',
    button: true,
    child: GestureDetector(
      onTap: onTap ?? () => open(context, '/book', arguments: book),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          book.image,
          width: width,
          height: height ?? width * 1.54,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar(this.asset, {super.key, this.size = 40});
  final String asset;
  final double size;
  @override
  Widget build(BuildContext context) => ClipOval(
    child: Image.asset(
      'assets/images/$asset.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(
    this.title, {
    super.key,
    this.onTap,
    this.label = 'view all',
  });
  final String title, label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ),
        if (onTap != null)
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: muted),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

class BookGrid extends StatelessWidget {
  const BookGrid(this.items, {super.key, this.columns = 3});
  final List<Book> items;
  final int columns;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = (constraints.maxWidth - (columns - 1) * 18) / columns;
      return Wrap(
        spacing: 18,
        runSpacing: 28,
        children: items
            .map(
              (b) => SizedBox(
                width: width,
                child: InkWell(
                  onTap: () => open(context, '/book', arguments: b),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Cover(b, width: width),
                      const SizedBox(height: 12),
                      Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        b.author,
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    },
  );
}

class BookRow extends StatelessWidget {
  const BookRow(this.book, {super.key, this.rating = false, this.trailing});
  final Book book;
  final bool rating;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => open(context, '/book', arguments: book),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Cover(book, width: 84),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (rating)
                  const Text(
                    '★★★★★  5.0',
                    style: TextStyle(color: pink, fontSize: 19),
                  )
                else
                  Text(
                    'Author:  ${book.author}',
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                const SizedBox(height: 12),
                Text(
                  book.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                if (rating)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '354 people read',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.secondary = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool secondary;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: secondary ? muted : pink,
        foregroundColor: secondary ? background : const Color(0xFF181B23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget searchBox(BuildContext context) => InkWell(
  onTap: () => open(context, '/search'),
  child: Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Row(
      children: [
        Icon(Icons.search, size: 21, color: muted),
        SizedBox(width: 12),
        Text('Search…', style: TextStyle(fontSize: 16, color: muted)),
      ],
    ),
  ),
);
