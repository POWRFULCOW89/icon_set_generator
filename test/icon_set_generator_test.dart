import 'package:icon_set_generator/icon_set_generator.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  // Directory dir = Directory.current
  //     .createTempSync('test' + Platform.pathSeparator + 'test_rename');

  Directory dir = Directory('./out');

  // setUpAll(() {
  //   for (var i = 0; i < 5; i++) {
  //     var file = File(dir.path + '/test_rename_$i.txt');
  //     file.createSync();

  //     if (i % 2 == 0) {
  //       final subdir = dir.createTempSync('test_rename_subdir');
  //       var file = File(subdir.path + '/test_rename_subdir$i.txt');
  //       file.createSync();
  //     }
  //   }
  // });

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
      all.removeWhere((element) => element > 256);

      expect(n, equals(all.length));
      expect(dir.listSync().length, equals(all.toSet().length));
    });

    // test('Correctly strips no substrings.', () async {
    //   int n = await rename(dir.path, 'thisdoesnotexist', '', false, false);
    //   expect(n, equals(0));
    // });

    // test('Correctly strips substrings recursively.', () async {
    //   int n = await rename(dir.path, 'test_', '', true, false);
    //   expect(n, equals(8));
    //   dir.listSync(recursive: true).forEach((f) {
    //     expect(f.uri.pathSegments.last.contains('test_'), isFalse);
    //   });
    // });

    // test('Correctly strips no substrings recursively.', () async {
    //   int n = await rename(dir.path, 'thisdoesnotexist', '', true, false);
    //   expect(n, equals(0));
    // });

    // test('Correctly replaces substrings with a new string', () async {
    //   int n = await rename(dir.path, 're_', 'RecordNumber', false, false);
    //   expect(n, equals(5));
    //   dir.listSync().forEach((f) {
    //     expect(f.uri.pathSegments.last.contains('re_'), isFalse);
    //   });
    // });

    // test('Correctly replaces substrings with a new string recursively',
    //     () async {
    //   int n = await rename(
    //       dir.path, 'rename_subdir', 'SubArchive No.', true, false);
    //   expect(n, equals(3));
    //   dir.listSync(recursive: true).forEach((f) {
    //     expect(f.uri.pathSegments.last.contains('rename_subdir'), isFalse);
    //   });
    // });

    // test('Correctly replaces substrings with a new string numbered recursively',
    //     () async {
    //   int n = await rename(dir.path, 'SubArchive No.', 'File', true, true);
    //   // expect(n, equals(3));

    //   final files = dir.listSync(recursive: true);
    //   int count = 0;
    //   files.asMap().forEach((i, f) {
    //     String name = f.uri.pathSegments.last;
    //     if (name.startsWith('File')) count++;
    //   });
    //   expect(count, equals(n));
    // });

    // test('Correctly strips substrings with RegEx', () async {
    //   int n = await rename(dir.path, '[re]', '', false, false);
    //   expect(n, equals(5));

    //   dir.listSync().forEach((f) {
    //     String name = f.uri.pathSegments.last;

    //     if (name.endsWith('.txt')) {
    //       expect(f.uri.pathSegments.last.startsWith('RcodNumb'), isTrue);
    //     }
    //   });
    // });

    // test('Correctly replaces substrings with RegEx recursively', () async {
    //   int n = await rename(dir.path, 'F...', 'Entry[123]', true, false);
    //   expect(n, equals(3));

    //   final files = dir.listSync(recursive: true);
    //   int count = 0;
    //   files.asMap().forEach((i, f) {
    //     String name = f.uri.pathSegments.last;
    //     if (name.startsWith('Entry')) count++;
    //   });
    //   expect(count, equals(n));
    // });

    // test('Correctly strips substrings with RegEx numbered recursively',
    //     () async {
    //   int n = await rename(dir.path, '\\[(.*?)\\]\\d*', '', true, true);
    //   expect(n, equals(3));

    //   final files = dir.listSync(recursive: true);
    //   int count = 0;
    //   files.asMap().forEach((i, f) {
    //     String name = f.uri.pathSegments.last;
    //     if (name.startsWith('Entry')) count++;
    //   });
    //   expect(count, equals(n));
    // });

    // test('Correctly change file extension.', () async {
    //   int n = await rename(dir.path, 'txt', 'csv', false, false);
    //   expect(n, equals(5));
    //   dir.listSync().forEach((f) {
    //     expect(f.uri.pathSegments.last.contains('txt'), isFalse);
    //   });
    // });
  });

  tearDown(() {
    dir.deleteSync(recursive: true);
  });
}
