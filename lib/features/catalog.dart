import 'package:flutter/material.dart';

import '../data/books.dart';
import '../ui/common.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: '',
    back: false,
    tab: 0,
    leading: IconButton(
      tooltip: 'Daily recommendation',
      onPressed: () => open(context, '/daily'),
      icon: const Icon(Icons.emoji_events, size: 21),
    ),
    actions: [
      IconButton(
        tooltip: 'Categories',
        icon: const Icon(Icons.menu),
        onPressed: () => open(context, '/category'),
      ),
    ],
    child: SingleChildScrollView(
      key: const Key('home-scroll'),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 14),
          searchBox(context),
          const SizedBox(height: 32),
          SectionHeading('Recommend', onTap: () => open(context, '/category')),
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final name = ['Success', 'Life', 'Camping', 'Experience'][i];
                return InkWell(
                  onTap: () => open(context, '/success', arguments: name),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'assets/images/${name.toLowerCase()}.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(name, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 46),
          SectionHeading(
            'New book hot list',
            onTap: () => open(context, '/success'),
          ),
          BookGrid(books.take(6).toList()),
          const SizedBox(height: 46),
          const SectionHeading('Search hours'),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              for (final (i, name) in [
                'Celebrity pass',
                'History',
                'Flood',
                'Harvard University Economics',
                'Leadership',
              ].indexed)
                ActionChip(
                  label: Text(name, style: const TextStyle(fontSize: 11)),
                  backgroundColor: background,
                  side: BorderSide(
                    color: [
                      Colors.blue.shade200,
                      Colors.green.shade200,
                      pink,
                      Colors.purple.shade200,
                      Colors.orange.shade200,
                    ][i],
                  ),
                  shape: const StadiumBorder(),
                  onPressed: () => open(context, '/search', arguments: name),
                ),
            ],
          ),
          const SizedBox(height: 44),
          SectionHeading(
            'Popular books',
            onTap: () => open(context, '/success'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(4),
            ),
            child: BookRow(
              books.first,
              trailing: const Icon(Icons.more_horiz, color: muted),
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => open(context, '/daily'),
            icon: const Icon(Icons.auto_stories_outlined),
            label: const Text('A good book every day'),
          ),
          TextButton.icon(
            onPressed: () => open(context, '/writers'),
            icon: const Icon(Icons.people_outline),
            label: const Text('Discover writers'),
          ),
        ],
      ),
    ),
  );
}

class FindPage extends StatefulWidget {
  const FindPage({super.key, this.grid = false});
  final bool grid;
  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  late bool grid = widget.grid;
  int selected = 1;
  final pageController = PageController(initialPage: 1, viewportFraction: .75);
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Find',
    back: false,
    tab: 1,
    actions: [
      IconButton(
        tooltip: 'Grid view',
        onPressed: () => setState(() => grid = true),
        icon: Icon(Icons.grid_view_rounded, color: grid ? Colors.white : muted),
      ),
      IconButton(
        tooltip: 'Focus view',
        onPressed: () => setState(() => grid = false),
        icon: Icon(
          Icons.crop_portrait_rounded,
          color: !grid ? Colors.white : muted,
        ),
      ),
    ],
    child: grid
        ? SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(46, 42, 46, 30),
            child: BookGrid([
              books[1],
              books[2],
              books[0],
              books[3],
            ], columns: 2),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 28),
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: 3,
                    onPageChanged: (i) => setState(() => selected = i),
                    itemBuilder: (context, i) =>
                        Center(child: Cover(books[i], width: 195, height: 290)),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65),
                  child: Text(
                    books[selected].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, height: 1.3),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  books[selected].author,
                  style: const TextStyle(color: muted, fontSize: 15),
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final avatar in [
                      'author',
                      'charlene',
                      'yvette',
                      'gillian',
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Avatar(avatar, size: 34),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  '457 people are reading',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => open(context, '/author'),
                    icon: const Avatar('teny', size: 32),
                    label: const Text(
                      'Mike recommends',
                      style: TextStyle(color: muted),
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.query = ''});
  final String query;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final controller = TextEditingController(text: widget.query);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    final query = controller.text.trim().toLowerCase();
    final results = books
        .where(
          (b) => '${b.title} ${b.author} ${b.category}'.toLowerCase().contains(
            query,
          ),
        )
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 12, 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('search-field'),
                      controller: controller,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: store.search,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search…',
                        prefixIcon: const Icon(Icons.search, size: 21),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  controller.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (query.isNotEmpty) ...[
                      SectionHeading(
                        'Results',
                        label: '${results.length} books',
                      ),
                      if (results.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Text(
                            'No books found. Try a title, writer or category.',
                            style: TextStyle(color: muted),
                          ),
                        ),
                      for (final b in results) BookRow(b),
                    ] else ...[
                      SectionHeading(
                        'popular searches',
                        onTap: () => open(context, '/success'),
                      ),
                      BookGrid([books[3], books[6], books[4]], columns: 3),
                      const SizedBox(height: 42),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'History',
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Clear history',
                            onPressed: () {
                              store.history.clear();
                              store.save();
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: store.history
                            .map(
                              (q) => ActionChip(
                                backgroundColor: raised,
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                                label: Text(
                                  q,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  controller.text = q;
                                  store.search(q);
                                  setState(() {});
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 6,
    child: PageFrame(
      title: 'Category',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: searchBox(context),
          ),
          const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: pink,
            labelColor: Colors.white,
            unselectedLabelColor: muted,
            dividerColor: line,
            tabs: [
              Tab(text: 'Economic'),
              Tab(text: 'Military'),
              Tab(text: 'Art'),
              Tab(text: 'Movement'),
              Tab(text: 'Design'),
              Tab(text: 'Science'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: List.generate(
                6,
                (i) => SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SectionHeading(
                        'New book hot list',
                        onTap: () => open(context, '/success'),
                      ),
                      BookGrid(
                        i == 0
                            ? books.take(3).toList()
                            : [
                                books[(i + 1) % 6],
                                books[i % 6],
                                books[(i + 3) % 6],
                              ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 26),
                        child: Divider(),
                      ),
                      SectionHeading(
                        'Popular books',
                        onTap: () => open(context, '/success'),
                      ),
                      BookGrid(books.skip(3).take(3).toList()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class BookListPage extends StatelessWidget {
  const BookListPage({
    super.key,
    this.title = 'Success',
    this.onlyPurchased = false,
  });
  final String title;
  final bool onlyPurchased;
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    final items = onlyPurchased
        ? books.where((b) => store.purchased.contains(b.id)).toList()
        : books;
    return PageFrame(
      title: title,
      actions: [
        IconButton(
          tooltip: 'Categories',
          onPressed: () => open(context, '/category'),
          icon: const Icon(Icons.menu),
        ),
      ],
      child: items.isEmpty
          ? const Center(
              child: Text(
                'Your purchased books will appear here.',
                style: TextStyle(color: muted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: BookRow(
                  items[i],
                  trailing: IconButton(
                    tooltip: 'Add to bookshelf',
                    onPressed: () {
                      store.addBook(items[i].id);
                      message(context, 'Added to your library');
                    },
                    icon: const Icon(Icons.more_horiz, color: muted),
                  ),
                ),
              ),
            ),
    );
  }
}

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    final ids = [
      'water',
      'cannes',
      'gorilla',
      ...store.shelf.where(
        (id) => !['water', 'cannes', 'gorilla'].contains(id),
      ),
    ];
    final saved = ids
        .where(store.shelf.contains)
        .map((id) => books.firstWhere((book) => book.id == id))
        .toList();
    return PageFrame(
      title: 'Bookshelf',
      back: false,
      tab: 2,
      actions: [
        IconButton(
          tooltip: 'Categories',
          onPressed: () => open(context, '/category'),
          icon: const Icon(Icons.menu),
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 222,
              child: saved.isEmpty
                  ? const Center(child: Text('Add your first book'))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: saved.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (context, i) => SizedBox(
                        width: saved[i].id == 'cannes' ? 115 : 88,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Cover(
                                  saved[i],
                                  width: saved[i].id == 'cannes' ? 115 : 88,
                                  onTap: () => open(
                                    context,
                                    '/reader',
                                    arguments: saved[i],
                                  ),
                                ),
                                const Positioned(
                                  right: 10,
                                  top: 0,
                                  child: Icon(
                                    Icons.bookmark,
                                    color: Colors.orange,
                                    size: 21,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              saved[i].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 25),
            SectionHeading(
              'Reading',
              onTap: () => open(context, '/success', arguments: 'Reading'),
            ),
            BookGrid([books[3], books[6], books[4]]),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Add books',
                onPressed: () => open(context, '/search'),
                icon: const Icon(Icons.add, color: muted),
              ),
            ),
            const SizedBox(height: 18),
            SectionHeading(
              'Finished',
              onTap: () => open(context, '/success', arguments: 'Finished'),
            ),
            BookGrid([books[3], books[6]]),
          ],
        ),
      ),
    );
  }
}

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});
  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Close recommendation',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.close, color: muted),
            ),
          ),
          const Text(
            'A good book\nevery day',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              onPageChanged: (i) => setState(() => index = i),
              itemBuilder: (context, i) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Cover(books[i], width: 195, height: 290),
                  const SizedBox(height: 38),
                  Text(
                    books[i].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 23),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    books[i].author,
                    style: const TextStyle(color: muted, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Container(
                width: 18,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: index == i
                      ? Colors.white
                      : muted.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    ),
  );
}
