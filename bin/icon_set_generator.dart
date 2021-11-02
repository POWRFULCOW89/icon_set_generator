import 'package:icon_set_generator/icon_set_generator.dart'
    as icon_set_generator;
import 'package:args/args.dart' show ArgParser, ArgResults;

void main(List<String> arguments) async {
  ArgParser parser = ArgParser();

  parser.addFlag('windows10',
      abbr: 'w',
      help: 'Generate icon sets for Windows 10 apps.',
      negatable: false);
  parser.addFlag('help',
      abbr: 'h', help: 'Shows the CLI usage.', negatable: false);
  parser.addFlag('apple',
      abbr: 'a', help: 'Generate icon sets for Apple apps.', negatable: false);

  void printUsage([String? message]) {
    print(message);
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
    String path = './test/js.png';

    int iconCount = await icon_set_generator.generateIconSet(path);

    if (iconCount > 1) {
      print('Successfully renamed $iconCount files.');
    } else {
      print('No files renamed.');
    }
  }
}
