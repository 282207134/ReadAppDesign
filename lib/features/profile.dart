import 'package:flutter/material.dart';

import '../data/books.dart';
import '../ui/common.dart';
import 'book_details.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.author = false});
  final bool author;
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    final following = store.following.contains('Marlene Anna');
    return PageFrame(
      title: author ? 'The author' : 'Mine',
      back: author,
      tab: author ? null : 3,
      actions: author
          ? null
          : [
              IconButton(
                tooltip: 'Settings',
                onPressed: () => open(context, '/settings'),
                icon: const Icon(Icons.settings, size: 22),
              ),
            ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (author)
                  const Avatar('author', size: 120)
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/profile.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        'Marlene Anna',
                        style: TextStyle(fontSize: 23),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        author ? 'New York, NY' : 'San Diego, CA',
                        style: const TextStyle(color: muted, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          SizedBox(
                            height: 32,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () => showShare(context, books.first),
                              child: const Text(
                                '↗ Share',
                                style: TextStyle(color: muted, fontSize: 12),
                              ),
                            ),
                          ),
                          if (author)
                            SizedBox(
                              height: 32,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF438FE2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () => store.follow('Marlene Anna'),
                                child: Text(
                                  following ? 'Following' : 'Follow',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Container(
              height: 64,
              color: panel,
              child: Row(
                children: [
                  for (final (i, label) in [
                    'Following',
                    'Followers',
                    'Like',
                  ].indexed)
                    Expanded(
                      child: InkWell(
                        onTap: () => open(context, '/writers'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ['818', following ? '1438' : '1437', '6673'][i],
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              label,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (author) ...[
              const SectionHeading('Representative work'),
              for (final b in books.take(3)) ...[
                BookRow(b, rating: true),
                const Divider(),
              ],
            ] else ...[
              const Text('Information', style: TextStyle(fontSize: 19)),
              const SizedBox(height: 12),
              const Divider(),
              _row(
                'My message',
                () => info(
                  context,
                  'My message',
                  'You’re all caught up. Reading notifications will appear here.',
                ),
                subtitle: 'Acceptable information',
                trailing: const Icon(Icons.circle, color: Colors.blue, size: 8),
              ),
              _row(
                'My collection',
                () => open(context, '/bookshelf'),
                trailing: TextButton(
                  onPressed: () => writeReview(context),
                  child: const Text('Write'),
                ),
              ),
              _row(
                'Balance: \$${store.balance.toStringAsFixed(0)}',
                () => open(context, '/payment'),
                trailing: FilledButton(
                  onPressed: () => open(context, '/payment'),
                  child: const Text('Recharge'),
                ),
              ),
              _row(
                'My book review',
                () => open(context, '/comments'),
                subtitle: 'Write your own book review',
              ),
              _row('My purchase', () => open(context, '/purchases')),
              _row(
                'Help and feedback',
                () => info(
                  context,
                  'Help and feedback',
                  'Explore books, add them to your library, and tap Trial reading to start. Progress is saved on this device.',
                ),
                subtitle: 'Promptly help your problems',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(
    String title,
    VoidCallback action, {
    String? subtitle,
    Widget? trailing,
  }) => Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 19,
        title: Text(title, style: const TextStyle(fontSize: 18)),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 13),
              ),
        trailing: trailing,
        onTap: action,
      ),
      const Divider(height: 1),
    ],
  );
}

void info(BuildContext context, String title, String text) => showDialog<void>(
  context: context,
  builder: (c) => AlertDialog(
    backgroundColor: raised,
    title: Text(title),
    content: Text(text),
    actions: [
      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close')),
    ],
  ),
);

class WritersPage extends StatelessWidget {
  const WritersPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    return PageFrame(
      title: 'Writer',
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final i in [1, 0, 2])
                  Expanded(
                    child: InkWell(
                      onTap: () => open(context, '/author'),
                      child: Column(
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: [
                              Colors.amber,
                              const Color(0xFFFF6356),
                              Colors.cyan,
                            ][i],
                            size: i == 0 ? 48 : 32,
                          ),
                          Avatar(authorImages[i], size: i == 0 ? 100 : 75),
                          const SizedBox(height: 14),
                          Text(
                            i == 0 ? '① Amenda' : authorNames[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: i == 0 ? 20 : 15),
                          ),
                          const SizedBox(height: 6),
                          const FittedBox(
                            child: Text(
                              '4684 Followers',
                              style: TextStyle(color: muted, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 42),
            for (final (section, indices) in [
              ('Hot writers', [3, 4, 5, 6]),
              ('New Writers', [2, 1, 0, 5]),
              ('Other writers', [6, 3, 2, 4]),
            ]) ...[
              SectionHeading(section, onTap: () => open(context, '/author')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final i in indices)
                    Flexible(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => open(context, '/author'),
                            child: Avatar(authorImages[i], size: 60),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            authorNames[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 26,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                backgroundColor:
                                    store.following.contains(authorNames[i])
                                    ? const Color(0xFF438FE2)
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              onPressed: () => store.follow(authorNames[i]),
                              child: Text(
                                store.following.contains(authorNames[i])
                                    ? 'Following'
                                    : 'Follow',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Divider(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    return PageFrame(
      title: 'Settings',
      bottom: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SizedBox(
            height: 66,
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: panel),
              onPressed: () => info(
                context,
                'Local reading profile',
                'This demo uses a local profile. There is no remote account to sign out of.',
              ),
              child: const Text(
                'Sign out',
                style: TextStyle(fontSize: 23, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _setting(
            'View account',
            () => info(context, 'Account', 'Marlene Anna · Local profile'),
          ),
          _setting('Personal information', () => open(context, '/author')),
          SizedBox(
            height: 72,
            child: Row(
              children: [
                const Expanded(
                  child: Text('Notice', style: TextStyle(fontSize: 18)),
                ),
                Switch(
                  value: store.notice,
                  activeThumbColor: Colors.white,
                  activeTrackColor: pink,
                  onChanged: (value) {
                    store.notice = value;
                    store.save();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _setting(
            'Clear cache',
            () => message(
              context,
              'Cache cleared. Books and reading progress are kept.',
            ),
            detail: '0 MB',
          ),
          _setting(
            'Feedback',
            () => info(
              context,
              'Feedback',
              'This offline demo has no feedback server. Record issues with a screenshot and page name.',
            ),
          ),
          _setting(
            'About PostIt',
            () => info(
              context,
              'PostIt · Read app',
              'Version 1.0.0\nBuilt with Flutter from the Pixso Read app design.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _setting(String title, VoidCallback action, {String? detail}) =>
      Column(
        children: [
          SizedBox(
            height: 72,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(title, style: const TextStyle(fontSize: 18)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (detail != null)
                    Text(
                      detail,
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: muted, size: 20),
                ],
              ),
              onTap: action,
            ),
          ),
          const Divider(height: 1),
        ],
      );
}
