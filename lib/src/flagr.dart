import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ffcache/ffcache.dart';
import 'package:flutter_flagr/src/evaluation_request.dart';
import 'package:flutter_flagr/src/flags.dart';
import 'package:http/http.dart' as http;

import 'evaluation_response.dart';

const _KEY_CACHE_NAME = 'flagr_enabled';
const _DEFAULT_TIMEOUT_DURATION = Duration(days: 1);
const _DEFAULT_FETCH_TIMEOUT = Duration(seconds: 30);

class Flagr {
  Flagr._internal(this._url, this._tags, this._expiration,
      this._minimumFetchInterval, this._fetchTimeout, this._debugMode);

  static Flagr _instance;

  final String _url;

  final String _tags;

  final Duration _minimumFetchInterval;

  final Duration _fetchTimeout;

  final Duration _expiration;

  final http.Client _client = http.Client();

  final bool _debugMode;

  FFCache _cache;

  List<Flag> _flags;

  Timer _togglePollingTimer;

  static Flagr get instance {
    if (_instance == null) throw Exception('Flagr must be initialized first.');
    return _instance;
  }

  static Future<Flagr> init(
    String api, {
    String tags,
    Duration expiration = _DEFAULT_TIMEOUT_DURATION,
    Duration minimumFetchInterval,
    Duration fetchTimeout = _DEFAULT_FETCH_TIMEOUT,
    bool debugMode = false,
  }) async {
    assert(!fetchTimeout.isNegative);

    if (fetchTimeout.inSeconds == 0) {
      fetchTimeout = const Duration(seconds: 60);
    }

    _instance = Flagr._internal(
      api,
      tags,
      expiration,
      minimumFetchInterval,
      fetchTimeout,
      debugMode,
    );

    _instance._cache = FFCache(defaultTimeout: expiration);
    await _instance._cache.init();

    await _instance._loadToggles();

    _instance._setTogglePollingTimer();

    return _instance;
  }

  Future<void> _loadToggles() async {
    String url = _url + "/flags";

    if (_tags != null) {
      url = url + "?tags=${_tags.replaceAll(new RegExp(r"\s+"), "")}";
    }

    Duration timeout = _expiration == Duration(seconds: 0)
        ? Duration(seconds: -1)
        : _cache.remainingDurationForKey(_KEY_CACHE_NAME);

    if (timeout.isNegative) {
      final response = await _client.get(url).timeout(_fetchTimeout);

      if (response.statusCode == 200) {
        await _cache.clear();
        await _cache.setJSON(_KEY_CACHE_NAME, response.body);
        _flags = flagsFromJson(response.body);
      } else {
        throw HttpException(response.body, uri: Uri.parse(url));
      }

      if (_debugMode) {
        print('flutter_flagr: FETCH FROM NETWORK');
        print('flutter_flagr: ${response.body}');
      }
    } else {
      final jsonData = await _cache.getJSON(_KEY_CACHE_NAME);
      _flags = flagsFromJson(jsonData);
      if (_debugMode) {
        print('flutter_flagr: FETCH FROM CAHCE');
        print('\flutter_flagr: $jsonData');
      }
    }
  }

  void _setTogglePollingTimer() {
    if (_minimumFetchInterval == null) {
      return;
    }

    _togglePollingTimer = Timer.periodic(_minimumFetchInterval, (timer) {
      _loadToggles();
    });
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
      print('flutter_flagr: unable to find flag $flagKey in the database. '
          'Default value is used.');
      return defaultFlag;
    });

    final toggle = featureFlag ?? defaultFlag;

    if (_debugMode)
      print(
          'flutter_flagr: flag $flagKey is ${toggle.enabled ? 'ENABLED' : 'DISABLED'}');

    return toggle.enabled ?? defaultValue;
  }

  Future<EvaluationResponse> postEvaluation(
      EvaluationContext evaluationContext) async {
    final response = await _client
        .post(_url + "/evaluation",
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(
                evaluationContext != null ? evaluationContext.toJson() : null))
        .timeout(_fetchTimeout);

    if (_debugMode) {
      print('flutter_flagr: POST EVALUATION RESPONSE');
      print('flutter_flagr: ${response.body}');
    }

    return EvaluationResponse.fromJson(json.decode(response.body));
  }

  Future<void> invalidateCahce() async => await _cache.clear();

  void dispose() {
    _client.close();
    _togglePollingTimer?.cancel();
  }
}
