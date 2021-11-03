import 'package:icon_set_generator/icon_set_generator.dart';
// as icon_set_generator;
import 'package:args/args.dart' show ArgParser, ArgResults;

void main(List<String> arguments) async {
  ArgParser parser = ArgParser();

  parser.addOption('extension',
      abbr: 'e', help: 'Extension to convert the set to.');
  parser.addOption('output', abbr: 'o', help: 'Output directory.');
  parser.addOption('set', abbr: 's', help: 'Custom set of sizes');
  parser.addFlag('windows10',
      abbr: 'w',
      help: 'Generate icon sets for Windows 10 apps.',
      negatable: false);
  parser.addFlag('help',
      abbr: 'h', help: 'Shows the CLI usage.', negatable: false);
  parser.addFlag('apple',
      abbr: 'a', help: 'Generate icon sets for Apple apps.', negatable: false);

  void printUsage([String? message]) {
    print("info: $message");
    print(parser.usage);
  }

  ArgResults args = parser.parse(arguments);

  if (args['help']) {
    printUsage();
  }

  if (args.rest.length > 1) {
    printUsage('Too many arguments.');
  } else if (args.rest.isEmpty) {
    printUsage('No arguments provided.');
  } else {
    String path = args.rest.first; // takes a single positional argument

    List<int> sets = [];
    String ext = args['extension'];

    sets.addAll(standardSet);

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
