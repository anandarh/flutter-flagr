import 'package:flutter/foundation.dart';
import 'package:flutter_flagr/src/evaluation_request.dart';
import 'package:flutter_flagr/src/flags.dart';
import 'package:http/http.dart' as http;

class Flagr {
  Flagr._internal(this._url, this._client);

  final String _url;

  final http.Client _client;

  List<Flag> _flags;

  static Flagr _instance;

  static Flagr get instance {
    if (_instance == null)
      throw Exception(
          'Flagr must be initialized first. \nFlagr.init(api: API_URL);');
    return _instance;
  }

  static Future<Flagr> init(
      {@required String api, Evaluation evaluation}) async {
    _instance = Flagr._internal(api, http.Client());
    await _instance._loadToggles();
    return _instance;
  }

  String get url => _url;

  void dispose() {
    _client.close();
  }

  Future<void> _loadToggles() async {
    final reponse = await _client.get(
      _url + "/flags",
    );

    _flags = flagsFromJson(reponse.body);
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

    final featureFlag = _flags?.firstWhere((flag) => flag.key == flagKey,
        orElse: () => defaultFlag);

    final toggle = featureFlag ?? defaultFlag;

    return toggle.enabled ?? defaultValue;
  }
}
