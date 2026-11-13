import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/books.dart';
import '../ui/common.dart';

const readingParagraphs = [
  'A generalized polygon layer of Miami-Dade County water bodies is a derivative of the original cartographic layer.',
  'It was generalized using the Generalization tool, selecting the Bend Simplify option with an offset tolerance of five feet. The result invites us to see the landscape in a different way.',
  'A collection of vector polygons describes water bodies within the Urban Development Boundary and covers approximately 938 square miles.',
  'The planimetric layer was previously updated by Aerial Cartographics. The work comprised two individual updates: inside the urban boundary and beyond it.',
  'Maps are more than records of places. They are stories about how we understand the world, and how we choose to move through it.',
];

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.book, this.highlight = false});
  final Book book;
  final bool highlight;
  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late bool tools = widget.highlight;
  int color = 0;
  final colors = [
    pink,
    Colors.cyan,
    Colors.amber,
    Colors.lightGreen,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    final highlightKey = '${widget.book.id}:${store.chapter}';
    final marked = widget.highlight || store.highlights.contains(highlightKey);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      'Chapter ${store.chapter}  details',
                      style: const TextStyle(fontSize: 13, color: muted),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Reading settings',
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: raised,
                      builder: (c) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Reading size',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      'A−',
                                      secondary: true,
                                      onPressed: () {
                                        store.fontSize = (store.fontSize - 2)
                                            .clamp(16, 30);
                                        store.save();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: PrimaryButton(
                                      'A+',
                                      onPressed: () {
                                        store.fontSize = (store.fontSize + 2)
                                            .clamp(16, 30);
                                        store.save();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.text_fields, color: muted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (i, text) in readingParagraphs.indexed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: GestureDetector(
                          onLongPress: () => setState(() => tools = !tools),
                          child: SelectableText(
                            text,
                            onSelectionChanged: (selection, cause) {
                              if (!selection.isCollapsed &&
                                  cause == SelectionChangedCause.longPress) {
                                setState(() => tools = true);
                              }
                            },
                            style: TextStyle(
                              fontSize: store.fontSize,
                              height: 1.5,
                              letterSpacing: .1,
                              color: const Color(0xFFE6E3DE),
                              backgroundColor: marked && i == 1
                                  ? colors[color].withValues(alpha: .22)
                                  : null,
                              decoration: marked && i == 0
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor: colors[color],
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (tools)
              Container(
                color: raised,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    for (final (i, value) in colors.indexed)
                      Expanded(
                        child: IconButton(
                          tooltip: 'Highlight color ${i + 1}',
                          onPressed: () {
                            setState(() => color = i);
                            store.highlights.add(highlightKey);
                            store.save();
                          },
                          icon: Icon(Icons.circle, color: value, size: 20),
                        ),
                      ),
                    IconButton(
                      tooltip: 'Copy passage',
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: readingParagraphs[1]),
                        );
                        message(context, 'Passage copied');
                      },
                      icon: const Icon(Icons.copy, size: 20),
                    ),
                    IconButton(
                      tooltip: 'Close annotation tools',
                      onPressed: () => setState(() => tools = false),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  TextButton(
                    onPressed: store.chapter <= 1
                        ? null
                        : () {
                            store.chapter--;
                            store.save();
                          },
                    child: const Text('Previous'),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.book.title} · ${store.chapter}/12',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: muted),
                    ),
                  ),
                  TextButton(
                    onPressed: store.chapter >= 12
                        ? null
                        : () {
                            store.chapter++;
                            store.save();
                          },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
