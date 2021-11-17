# icon_set_generator

Simple CLI tool to enable easy production of icon sets for your next application.

## Installation

1. Clone the repo and add `bin/icon_set_generator.exe` to PATH:

    ```batch
    gh repo clone POWRFULCOW89/icon_set_generator
    ```

    or build from source:

    ```batch
    dart compile exe .\bin\icon_set_generator.dart
    ```
    
    or

2. [Get the pub package](https://pub.dev/packages/icon_set_generator/install):

    ``` batch
    dart pub add icon_set_generator
    ```    

    Refer to the [API docs](https://pub.dev/documentation/icon_set_generator/latest/icon_set_generator/generateIconSet.html) for library use.

3. Grab a prebuilt [binary](https://github.com/POWRFULCOW89/icon_set_generator/releases).


## Usage

```batch
icon_set_generator image.extension [-e] [-o] [-s] [-a] [-w] [-h]

-e, --extension    option: Extension to convert the set to.
-o, --output       option: Output directory.
-s, --set          option: Custom set of sizes
-a, --apple        flag: Generate icon sets for Apple apps.
-w, --windows10    flag: Generate icon sets for Windows 10 apps.
-h, --help         flag: Shows the CLI usage.
```

### Examples

1. Output a standard set from `favicon.png`:

    ```batch
    icon_set_generator favicon.png 
    ```

2. Output the standard, Apple and Windows 10 sets from `logo.jpg`:

    ```batch
    icon_set_generator logo.jpg -a -w
    ```

3. Output a custom size set from `image.gif` to the `samples` folder in `ICO` format:

    ```batch
    icon_set_generator image.gif -o samples --set "[10, 20, 30]" -e ico
    ```
