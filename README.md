# Flagr Client SDK for Flutter

This is an unofficial Flagr Client SDK for Flutter. Flagr is a feature flagging, A/B testing and dynamic configuration microservice. 
The base path for all the APIs is "/api/v1". [Flagr Open-Source](https://github.com/checkr/flagr).

## Getting Started

To use this plugin, add `flutter_flagr` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).
```
dependencies:
  flutter_flagr: ^0.0.1
```

To start using the Flutter Flagr package within your project, import the following package.

```
import 'package:flutter_flagr/flagr.dart';
```


Before using Flutter Flagr, you must first have ensured you have initialized Flutter Flagr.
```
Future<void> main() async {
  await Flagr.init('https://try-flagr.herokuapp.com/api/v1');

  runApp(MyApp());
}
```


To create a new Flagr instance, call the `instance` getter on `Flagr`:
```
final flagr = Flagr.instance;
```


Checking if a feature is enabled
```
// Will return `false` if it cannot find the flag key. 
flagr.isEnabled('flag_key')

// Specifying a default value:
flagr.isEnabled('flag_key', defaultValue: true)
```

