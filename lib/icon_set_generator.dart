/// Generate icons sets from an image to a wide array of
library icon_set_generator;

// Based on the image library by @brendan-duncan
import 'package:image/image.dart';
import 'dart:io';

/// The standard set of icons required for most applications.
const standardSet = [
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

/// The standard set of icons required for a Windows 10 application.
const w10 = [
  70,
  150,
  270,
  310,
];

/// The standard set of icons required for an iOS / MacOS application.
const apple = [
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

/// Returns the proper [Encoder] for the given [format].
///
/// Only the encoders that the image library supports are returned.
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

/// Returns the proper [Decoder] inferred from the file [name].
Function? getDecoder(String name) {
  final decoder = getDecoderForNamedImage(name);
  if (decoder == null) {
    return null;
  }
  return decoder.decodeImage;
}

void normalizeSet(List arr) {
  if (arr[0] is List) {
    for (var size in arr) {
      size.removeWhere((element) => element > 256);
    }
  } else {
    arr.removeWhere((element) => element > 256);
  }
}

/// Returns the number of icons produced in the [out] dir given an image [path].
///
/// - Additional icons can be produced by supplying a larger array.
/// - The icons produced can be converted to a specified [extension].
Future<int> generateIconSet(String path, List sets,
    {String? extension, String out = './out'}) async {
  /// The base image to produce icons for.
  File file;
  List iconSets = [...sets];

  try {
    file = File(path);
  } catch (e) {
    print("error: Image is corrupted or doesn't exist'");
    return -1;
  }

  if (iconSets.isEmpty) {
    return 0;
  }

  // The number of icons produced.
  int count = 0;

  // Getting file data.
  List<String> filename = file.uri.pathSegments.last.split('.');
  String name = filename[0];
  String fileExt = (extension ?? filename[1]).toLowerCase();

  Function? imageDecoder = getDecoder(filename.join('.'));
  Function? encodeImage = getEncoder(fileExt);

  // Quit if we can't operate on the image.
  if (imageDecoder == null) {
    print('error: No available decoder.');
    return -1;
  } else if (encodeImage == null) {
    print('error: No available encoder.');
    return -1;
  } else {
    Image image;

    try {
      image = imageDecoder(file.readAsBytesSync());
    } catch (e) {
      print("error: Corrupt or incomplete image.");
      return -1;
    }

    // Create the output folder if it doesn't exist.
    Directory dir = Directory(out);
    if (!await dir.exists()) {
      dir.createSync();
    }

    // ICO format only supports sizes of up to 256px
    if (fileExt.toLowerCase() == 'ico') {
      normalizeSet(iconSets);
    }

    // Generate icons.
    for (var size in iconSets) {
      Image resized;

      // if size is an array then get the two measures...
      if (size is List) {
        resized = copyResize(image, width: size[0], height: size[1]);
      } else {
        // ... else output a square image.
        resized = copyResize(image, width: size);
      }

      File(
        '$out/$name-$size.$fileExt',
      ).writeAsBytesSync(encodeImage(resized));
      count++;
    }

    return count;
  }
}
