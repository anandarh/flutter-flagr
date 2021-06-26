import 'dart:convert';

import 'evaluation_request.dart';

class EvaluationResponse {
  EvaluationResponse({
    this.flagId,
    this.flagKey,
    this.flagSnapshotId,
    this.segmentId,
    this.variantId,
    this.variantKey,
    this.variantAttachment,
    this.evalContext,
    this.timestamp,
    this.evalDebugLog,
  });

  final int flagId;
  final String flagKey;
  final int flagSnapshotId;
  final int segmentId;
  final int variantId;
  final String variantKey;
  final dynamic variantAttachment;
  final EvaluationContext evalContext;
  final String timestamp;
  final EvalDebugLog evalDebugLog;

  factory EvaluationResponse.fromJson(Map<String, dynamic> json) =>
      EvaluationResponse(
        flagId: json["flagID"] == null ? null : json["flagID"],
        flagKey: json["flagKey"] == null ? null : json["flagKey"],
        flagSnapshotId:
            json["flagSnapshotID"] == null ? null : json["flagSnapshotID"],
        segmentId: json["segmentID"] == null ? null : json["segmentID"],
        variantId: json["variantID"] == null ? null : json["variantID"],
        variantKey: json["variantKey"] == null ? null : json["variantKey"],
        variantAttachment: json["variantAttachment"] == null
            ? null
            : json["variantAttachment"],
        evalContext: json["evalContext"] == null
            ? null
            : EvaluationContext.fromJson(json["evalContext"]),
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        evalDebugLog: json["evalDebugLog"] == null
            ? null
            : EvalDebugLog.fromJson(json["evalDebugLog"]),
      );

  Map<String, dynamic> toJson() => {
        "flagID": flagId == null ? null : flagId,
        "flagKey": flagKey == null ? null : flagKey,
        "flagSnapshotID": flagSnapshotId == null ? null : flagSnapshotId,
        "segmentID": segmentId == null ? null : segmentId,
        "variantID": variantId == null ? null : variantId,
        "variantKey": variantKey == null ? null : variantKey,
        "variantAttachment":
            variantAttachment == null ? null : variantAttachment,
        "evalContext": evalContext == null ? null : evalContext.toJson(),
        "timestamp": timestamp == null ? null : timestamp,
        "evalDebugLog": evalDebugLog == null ? null : evalDebugLog.toJson(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class EvalDebugLog {
  EvalDebugLog({
    this.segmentDebugLogs,
    this.msg,
  });

  final List<SegmentDebugLog> segmentDebugLogs;
  final String msg;

  factory EvalDebugLog.fromJson(Map<String, dynamic> json) => EvalDebugLog(
        segmentDebugLogs: json["segmentDebugLogs"] == null
            ? null
            : List<SegmentDebugLog>.from(json["segmentDebugLogs"]
                .map((x) => SegmentDebugLog.fromJson(x))),
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "segmentDebugLogs": segmentDebugLogs == null
            ? null
            : List<dynamic>.from(segmentDebugLogs.map((x) => x.toJson())),
        "msg": msg == null ? null : msg,
      };
}

class SegmentDebugLog {
  SegmentDebugLog({
    this.segmentId,
    this.msg,
  });

  final int segmentId;
  final String msg;

  factory SegmentDebugLog.fromJson(Map<String, dynamic> json) =>
      SegmentDebugLog(
        segmentId: json["segmentID"] == null ? null : json["segmentID"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "segmentID": segmentId == null ? null : segmentId,
        "msg": msg == null ? null : msg,
      };
}
