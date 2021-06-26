import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_flagr/src/evaluation_request.dart';
import 'package:flutter_flagr/src/flags.dart';
import 'package:http/http.dart' as http;

import 'evaluation_response.dart';

class Flagr {
  Flagr._internal(
      this._url, this._client, this._minimumFetchInterval, this._fetchTimeout);

  final String _url;

  final http.Client _client;

  final Duration _minimumFetchInterval;

  final Duration _fetchTimeout;

  List<Flag> _flags;

  Timer _togglePollingTimer;

  static Flagr _instance;

  static Flagr get instance {
    if (_instance == null) throw Exception('Flagr must be initialized first.');
    return _instance;
  }

  static Future<Flagr> init(
    String api, {
    Duration minimumFetchInterval,
    Duration fetchTimeout = const Duration(seconds: 60),
  }) async {
    assert(!fetchTimeout.isNegative);

    if (fetchTimeout.inSeconds == 0) {
      fetchTimeout = const Duration(seconds: 60);
    }

    _instance =
        Flagr._internal(api, http.Client(), minimumFetchInterval, fetchTimeout);
    await _instance._loadToggles();
    _instance._setTogglePollingTimer();
    return _instance;
  }

  String get url => _url;

  void dispose() {
    _client.close();
    _togglePollingTimer?.cancel();
  }

  Future<void> _loadToggles() async {
    final response = await _client.get(
      _url + "/flags",
    );

    if (response.statusCode == 200) {
      _flags = flagsFromJson(response.body);
    } else {
      throw HttpException(response.body, uri: Uri.parse(url));
    }
  }

  bool isEnabled(String flagKey, {bool defaultValue = false}) {
    final defaultFlag = Flag(
        dataRecordsEnabled: null,
        description: null,
        enabled: defaultValue,
        id: null,
        key: flagKey,
        segments: null,
        tags: null,
        updatedAt: null,
        variants: null);

    final featureFlag =
        _flags?.firstWhere((flag) => flag.key == flagKey, orElse: () {
      print("flutter_flagr: unable to find flag $flagKey in the database. "
          "Default value is used.");
      return defaultFlag;
    });

    return featureFlag.enabled;
  }

  Future<EvaluationResponse> postEvaluation(
      EvaluationContext evaluationContext) async {
    final response = await _client
        .post(_url + "/evaluation",
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(
                evaluationContext != null ? evaluationContext.toJson() : null))
        .timeout(_fetchTimeout);
    return EvaluationResponse.fromJson(json.decode(response.body));
  }

  void _setTogglePollingTimer() {
    if (_minimumFetchInterval == null) {
      return;
    }

    _togglePollingTimer = Timer.periodic(_minimumFetchInterval, (timer) {
      _loadToggles();
    });
  }
}
