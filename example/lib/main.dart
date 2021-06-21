import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flagr/flutter_flagr.dart';

void main() async {
  await Flagr.init(api: String.fromEnvironment('API_URL'));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _isEnabled = 'Unknown';

  @override
  void initState() {
    super.initState();
    checkFlag();
  }

  Future<void> checkFlag() async {
    final flagr = Flagr.instance;

    final flag_key = String.fromEnvironment("FLAG_KEY");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isEnabled = flagr.isEnabled(flag_key, defaultValue: false).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_isEnabled\n'),
        ),
      ),
    );
  }
}
