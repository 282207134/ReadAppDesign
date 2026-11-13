import 'dart:io';
import 'dart:convert';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final names = <String>[];
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('docs/screenshots/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      names.add(name);
      return true;
    },
    responseDataCallback: (_) async {
      await File('docs/test-results.json').writeAsString(
        const JsonEncoder.withIndent('  ')
            .convert({'integrationTest': 'passed', 'screenshots': names}),
      );
    },
  );
}
