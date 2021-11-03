import 'package:icon_set_generator/icon_set_generator.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  // Dir to perform tests on
  Directory dir = Directory('./out');

  setUp(() {
    dir.createSync();
  });

  group('Icon output: ', () {
    test('Correctly outputs a standard set from PNG', () async {
      int n = await generateIconSet("./test/js.png", standardSet);
      expect(n, equals(standardSet.length));
      expect(dir.listSync().length, equals(standardSet.length));
    });

    test('Correctly outputs the windows set from JPG', () async {
      int n = await generateIconSet("./test/js.jpg", w10);
      expect(n, equals(w10.length));
      expect(dir.listSync().length, equals(w10.length));
    });

    test('Correctly outputs the Apple set from GIF', () async {
      int n = await generateIconSet("./test/js.gif", apple);
      expect(n, equals(apple.length));
      expect(dir.listSync().length, equals(apple.length));
    });

    test('Correctly outputs all sets from ICO', () async {
      int n = await generateIconSet(
          "./test/js.ico", [...standardSet, ...w10, ...apple]);
      List<int> all = [...standardSet, ...w10, ...apple];
      // all.removeWhere((element) => element > 256);
      normalizeSet(all);

      expect(n, equals(all.length));
      expect(dir.listSync().length, equals(all.toSet().length));
    });

    test('Correctly outputs a standard set from PNG to ICO', () async {
      int n =
          await generateIconSet("./test/js.png", standardSet, extension: 'ico');
      List<int> all = [...standardSet];
      normalizeSet(all);

      expect(n, equals(all.length));
      expect(dir.listSync().length, equals(all.toSet().length));

      // Check if all files in dir have the ico extension
      for (var file in dir.listSync()) {
        expect(file.path.endsWith('.ico'), isTrue);
      }
    });

    test('Correctly outputs a custom set from PNG in a subfolder', () async {
      const customSet = [100, 40, 1];

      int n = await generateIconSet("./test/js.png", customSet, out: './sub');
      expect(n, equals(customSet.length));
      Directory subdir = Directory('./sub');
      expect(subdir.listSync().length, equals(customSet.length));
      subdir.deleteSync(recursive: true);
    });

    test('Correctly outputs a custom set of sizes from PNG ', () async {
      const customSet = [
        [100, 200],
        [40, 60],
        [1, 100]
      ];

      int n = await generateIconSet("./test/js.png", customSet);
      expect(n, equals(customSet.length));
      expect(dir.listSync().length, equals(customSet.length));
    });

    test('Outputs nothing from an empty set from PNG', () async {
      const customSet = [];

      int n = await generateIconSet("./test/js.png", customSet);
      expect(n, equals(0));
      expect(dir.listSync().length, equals(0));
    });

    test('Fails to output a standard set from PNG', () async {
      int n = await generateIconSet("./test/image.png", standardSet);
      expect(n, equals(-1));
      expect(dir.listSync().length, equals(0));
    });

    test('Fails to output a standard set from an unknown format', () async {
      int n = await generateIconSet("./test/image.pc89", standardSet);
      expect(n, equals(-1));
      expect(dir.listSync().length, equals(0));
    });
  });

  tearDown(() {
    dir.deleteSync(recursive: true);
  });
}
