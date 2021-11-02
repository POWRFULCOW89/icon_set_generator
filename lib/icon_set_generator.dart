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

// enum Format { png, ico, jpg, gif, jpeg, tga }

Function? getEncoder(String format) {
  switch (format) {
    case 'png':
      return encodePng;
    case 'ico':
      return encodeIco;
    case 'jpg':
    case 'jpeg':
      return encodeJpg;
    case 'gif':
      return encodeGif;
    case 'tga':
      return encodeTga;
  }
}

Function? getDecoder(List<int> bytes, String name) {
  final decoder = getDecoderForNamedImage(name);
  if (decoder == null) {
    return null;
  }
  // return decoder.decodeImage(bytes);
  return decoder.decodeImage;
}

Future<int> generateIconSet(String path, {String? ext}) async {
  int count = 0;
  File file = File(path);
  List<String> filename = file.uri.pathSegments.last.split('.');
  String name = filename[0];
  String fileExt = ext ?? filename[1];

  // Image image = decodePng(file.readAsBytesSync()) as Image;

  Function? imageDecoder =
      getDecoder(file.readAsBytesSync(), filename.join('.'));

  Function? encodeImage = getEncoder(fileExt);

  if (imageDecoder == null) {
    print('No available decoder.');
    return -1;
  }

  // ignore: unnecessary_null_comparison
  else if (encodeImage == null) {
    print('No available encoder.');
    return -1;
  } else {
    Image image;

    try {
      image = imageDecoder(file.readAsBytesSync());
    } catch (e) {
      print("error: Corrupt or incomplete image.");
      return -1;
    }

    if (!await Directory('out').exists()) {
      Directory dir = Directory('out');
      dir.createSync();
    }

    for (var size in standard) {
      Image resized = copyResize(image, width: size);
      File(
        'out/$name-$size.$fileExt',
      ).writeAsBytesSync(encodeImage(resized));
      count++;
    }

    return count;
  }
}
