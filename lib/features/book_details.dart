import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/books.dart';
import '../ui/common.dart';

void showLibraryAdded(BuildContext context, Book book) {
  LibraryScope.of(context).addBook(book.id);
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: raised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Cover(book, width: 108, height: 160),
            const SizedBox(height: 26),
            const Text(
              'Already added to\nyour library',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                'Confirm',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showShare(BuildContext context, Book book) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: raised,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              tooltip: 'Close share',
              onPressed: () => Navigator.pop(sheetContext),
              icon: const Icon(Icons.close, size: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final (i, name) in [
                  'Facebook',
                  'Twitter',
                  'Messages',
                  'LinkedIn',
                ].indexed)
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: '${book.title} — ${book.author}'),
                      );
                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                        message(
                          context,
                          'Book recommendation copied. Paste it into $name to share.',
                        );
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: [
                            const Color(0xFF345697),
                            const Color(0xFF43B6E3),
                            const Color(0xFF99D657),
                            const Color(0xFF0789C7),
                          ][i],
                          child: Text(
                            ['f', 't', '•••', 'in'][i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(fontSize: 10, color: muted),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({super.key, required this.book, this.overlay});
  final Book book;
  final String? overlay;
  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.overlay == 'library') showLibraryAdded(context, widget.book);
      if (widget.overlay == 'share') showShare(context, widget.book);
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final store = LibraryScope.of(context);
    return PageFrame(
      title: '',
      bottom: SafeArea(
        top: false,
        child: Container(
          color: raised,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  'Trial reading',
                  secondary: true,
                  onPressed: () => open(context, '/reader', arguments: book),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  store.purchased.contains(book.id) ? 'Read book' : 'Buy',
                  onPressed: () => open(
                    context,
                    store.purchased.contains(book.id) ? '/reader' : '/buy',
                    arguments: book,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Cover(book, width: 108, height: 160),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(book.title, style: const TextStyle(fontSize: 23)),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () => open(context, '/author'),
                        child: Text(
                          'Author:  ${book.author}',
                          style: const TextStyle(color: muted, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        book.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '★★★★★  5.0',
                        style: TextStyle(color: pink, fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => store.toggleLike(book.id),
                      icon: Icon(
                        store.liked.contains(book.id)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: const Color(0xFFFF413C),
                        size: 22,
                      ),
                      label: Text(
                        store.liked.contains(book.id) ? 'Liked' : 'Like',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => showShare(context, book),
                      icon: const Icon(Icons.share, color: muted, size: 20),
                      label: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => showLibraryAdded(context, book),
                      icon: const Icon(Icons.bookmarks, color: muted, size: 20),
                      label: const Text(
                        'bookshelf',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 26),
            const Text('Details', style: TextStyle(fontSize: 19)),
            const SizedBox(height: 16),
            Text(
              book.description,
              style: const TextStyle(
                color: Color(0xFFBEC1CF),
                height: 1.9,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Check the directory',
                style: TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.chevron_right, color: muted),
              onTap: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: raised,
                builder: (sheetContext) => SafeArea(
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('Contents', style: TextStyle(fontSize: 22)),
                      ),
                      for (int i = 1; i <= 12; i++)
                        ListTile(
                          title: Text('Chapter $i'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            store.chapter = i;
                            store.save();
                            Navigator.pop(sheetContext);
                            open(context, '/reader', arguments: book);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 18),
            Row(
              children: [
                InkWell(
                  onTap: () => open(context, '/comments'),
                  child: const Text('Comment', style: TextStyle(fontSize: 19)),
                ),
                const SizedBox(width: 16),
                Text(
                  '${215 + store.reviews.length} reviews',
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Write review',
                  onPressed: () => writeReview(context),
                  icon: const Icon(Icons.edit_note),
                ),
              ],
            ),
            for (final review in [...store.reviews, ...initialReviews].take(2))
              ReviewTile(review),
            TextButton(
              onPressed: () => open(context, '/comments'),
              child: const Text('View all comments'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void writeReview(BuildContext context) {
  showDialog<void>(context: context, builder: (_) => const _ReviewEditor());
}

class _ReviewEditor extends StatefulWidget {
  const _ReviewEditor();
  @override
  State<_ReviewEditor> createState() => _ReviewEditorState();
}

class _ReviewEditorState extends State<_ReviewEditor> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    return AlertDialog(
      backgroundColor: raised,
      title: const Text('Write a book review'),
      content: TextField(
        key: const Key('review-field'),
        controller: controller,
        maxLines: 5,
        maxLength: 500,
        decoration: const InputDecoration(hintText: 'What did you think?'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.trim().isEmpty) return;
            store.reviews.insert(
              0,
              Review('Marlene Anna', 'profile', controller.text.trim()),
            );
            store.save();
            Navigator.pop(context);
          },
          child: const Text('Publish'),
        ),
      ],
    );
  }
}

class ReviewTile extends StatefulWidget {
  const ReviewTile(this.review, {super.key});
  final Review review;
  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool liked = false;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(widget.review.avatar, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.review.author,
                style: const TextStyle(fontSize: 14, color: Color(0xFFD5D5DF)),
              ),
              const SizedBox(height: 12),
              Text(
                widget.review.text,
                style: const TextStyle(color: muted, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '12-04 21:20',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => liked = !liked),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        liked ? '♥ 135' : '♥ 134',
                        style: TextStyle(
                          color: liked ? pink : muted,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    '♧ 89',
                    style: TextStyle(color: muted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
            ],
          ),
        ),
      ],
    ),
  );
}

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Comment',
    actions: [
      IconButton(
        tooltip: 'Write review',
        onPressed: () => writeReview(context),
        icon: const Icon(Icons.edit_note),
      ),
    ],
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        ...LibraryScope.of(context).reviews,
        ...initialReviews,
      ].map(ReviewTile.new).toList(),
    ),
  );
}
