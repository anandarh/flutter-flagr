import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flagr/flutter_flagr.dart';

void main() async {

  await Flagr.init(api: 'https://try-flagr.herokuapp.com/api/v1');

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

    final evaluationContext = EvaluationContext(
          entityId: "127",
          entityType: "user",
          entityContext: {
            "state": "CA"
          },
          flagId: 1,
          enableDebug: false
    );

    EvaluationResponse response = await flagr.postEvaluation(evaluationContext);
    print(response.toString());

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isEnabled = flagr
          .isEnabled('api_baseurl', defaultValue: false)
          .toString();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'is Enabled $_isEnabled',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
