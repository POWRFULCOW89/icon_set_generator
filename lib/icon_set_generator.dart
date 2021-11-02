import 'package:image/image.dart';
import 'dart:io';

/// Sources:
///
/// https://sympli.io/blog/heres-everything-you-need-to-know-about-favicons-in-2020/
/// https://blog.hubspot.com/website/what-is-a-favicon
///

final standard = [
  16, // Standard browser.
  32, // Taskbar shorcuts
  48,
  64,
  96, // Desktop shortcuts
  128,
  180, // Apple touch icons
  192, // Android
  196,
  228, // Opera Coast
  256,
  300, // Required by Squarespace
  512 // WordPress
];

final w10 = [
  70,
  150,
  270,
  310,
];

final apple = [
  57,
  60,
  72,
  76,
  114,
  120,
  144,
  152,
  180,
  192,
];

Future<int> generateIconSet(String path) async {
  int count = 0;
  Image image = decodePng(File(path).readAsBytesSync()) as Image;

  if (!await Directory('out').exists()) {
    Directory dir = Directory('out');
    dir.createSync();
  }

  for (var size in standard) {
    Image resized = copyResize(image, width: size);
    File(
      'out/standard-$size.png',
    ).writeAsBytesSync(encodePng(resized));
    count++;
  }

  return count;
}
