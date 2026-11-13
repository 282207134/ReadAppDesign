import 'package:flutter/material.dart';

import '../data/books.dart';
import '../ui/common.dart';

class BuyPage extends StatelessWidget {
  const BuyPage({super.key, required this.book});
  final Book book;
  @override
  Widget build(BuildContext context) {
    final store = LibraryScope.of(context);
    final owned = store.purchased.contains(book.id);
    return PageFrame(
      title: 'Clearing',
      bottom: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SizedBox(
            height: 64,
            child: PrimaryButton(
              owned ? 'Read book' : 'Buy',
              onPressed: () {
                if (owned) {
                  open(context, '/reader', arguments: book);
                  return;
                }
                if (!store.buy(book)) {
                  message(
                    context,
                    'Insufficient balance. Recharge to continue.',
                  );
                  return;
                }
                showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: raised,
                    title: const Text('Purchase complete'),
                    content: Text('${book.title} is now in your library.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          open(context, '/reader', arguments: book);
                        },
                        child: const Text('Start reading'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        BookRow(book),
                        Padding(
                          padding: const EdgeInsets.only(left: 100, bottom: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '\$${book.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.radio_button_checked, color: pink, size: 25),
                ],
              ),
            ),
          ),
          Container(
            color: raised,
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Balance: \$${store.balance.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                FilledButton(
                  onPressed: () => open(context, '/payment'),
                  child: const Text('Recharge'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Demo wallet · purchases use local credit only',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key, this.showCards = false});
  final bool showCards;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Payment',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        if (showCards)
          for (final (i, number) in ['4056', '3549', '6652'].indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _recharge(context, number),
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: LinearGradient(
                      colors: [
                        [const Color(0xFFB76BD9), const Color(0xFF7B53C6)],
                        [const Color(0xFF709CFF), const Color(0xFF5965FF)],
                        [const Color(0xFFFF8848), const Color(0xFFFF4773)],
                      ][i],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'DEMO CARD',
                        style: TextStyle(fontSize: 10, letterSpacing: 2),
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '**** ****',
                                style: TextStyle(
                                  fontSize: 25,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            number,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text('****', style: TextStyle(letterSpacing: 5)),
                    ],
                  ),
                ),
              ),
            ),
        InkWell(
          onTap: () =>
              showCards ? _addDemoCard(context) : open(context, '/cards'),
          child: Container(
            height: showCards ? 88 : 120,
            decoration: BoxDecoration(
              border: Border.all(color: muted),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('+', style: TextStyle(color: pink, fontSize: 23)),
                SizedBox(width: 10),
                Text(
                  'Add New Card',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: Text(
            'Demo payment methods. No real card data is collected or charged.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
  void _addDemoCard(BuildContext context) => showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      backgroundColor: raised,
      title: const Text('Demo cards ready'),
      content: const Text(
        'Choose one of the sample cards to add local reading credit.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
  void _recharge(BuildContext context, String number) => showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      backgroundColor: raised,
      title: const Text('Recharge'),
      content: Text('Add \$100 demo credit with card ending $number?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final store = LibraryScope.of(context);
            store.balance += 100;
            store.save();
            Navigator.pop(c);
            message(context, 'Added \$100 demo credit');
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
