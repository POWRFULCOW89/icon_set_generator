import 'package:icon_set_generator/icon_set_generator.dart';
// as icon_set_generator;
import 'package:args/args.dart' show ArgParser, ArgResults;
import 'dart:convert';

void main(List<String> arguments) async {
  ArgParser parser = ArgParser();

  parser.addOption('extension',
      abbr: 'e', help: 'option: Extension to convert the set to.');
  parser.addOption('output', abbr: 'o', help: 'option: Output directory.');
  parser.addOption('set', abbr: 's', help: 'option: Custom set of sizes');

  parser.addFlag('apple',
      abbr: 'a',
      help: 'flag: Generate icon sets for Apple apps.',
      negatable: false);
  parser.addFlag('windows10',
      abbr: 'w',
      help: 'flag: Generate icon sets for Windows 10 apps.',
      negatable: false);
  parser.addFlag('help',
      abbr: 'h', help: 'flag: Shows the CLI usage.', negatable: false);

  void printUsage([String? message]) {
    if (message != null) {
      print("info: $message");
    }
    print("""

Usage: icon_set_generator image.extension [-e] [-o] [-s] [-a] [-w] [-h]
    """);
    print(parser.usage);
  }

  ArgResults args = parser.parse(arguments);

  if (args['help']) {
    printUsage();
    return;
  }

  if (args.rest.length > 1) {
    printUsage('Too many arguments.');
  } else if (args.rest.isEmpty) {
    printUsage('No arguments provided.');
  } else {
    String path = args.rest.first; // takes a single positional argument

    // Use a custom set of sizes if provided, else the standard set
    List<dynamic> sets = args['set'] != null
        ? jsonDecode(args['set']) as List<dynamic>
        : standardSet;

    String? ext = args['extension'];

    if (args['windows10']) {
      sets.addAll(w10);
    } else if (args['apple']) {
      sets.addAll(apple);
    }

    int iconCount = await generateIconSet(path, sets, extension: ext);

    if (iconCount >= 1) {
      print('info: Successfully produced $iconCount icons.');
    } else {
      print('info: No icons produced.');
    }
  }
}
