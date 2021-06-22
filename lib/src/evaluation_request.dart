class EvaluationContext {
  EvaluationContext({
    this.entityId,
    this.entityType,
    this.entityContext,
    this.enableDebug,
    this.flagId,
    this.flagKey,
    this.flagTags,
    this.flagTagsOperator,
  });

  final String entityId;
  final String entityType;
  final dynamic entityContext;
  final bool enableDebug;
  final int flagId;
  final String flagKey;
  final List<String> flagTags;
  final String flagTagsOperator;

  factory EvaluationContext.fromJson(Map<String, dynamic> json) =>
      EvaluationContext(
        entityId: json["entityID"] == null ? null : json["entityID"],
        entityType: json["entityType"] == null ? null : json["entityType"],
        entityContext:
            json["entityContext"] == null ? null : json["entityContext"],
        enableDebug: json["enableDebug"] == null ? null : json["enableDebug"],
        flagId: json["flagID"] == null ? null : json["flagID"],
        flagKey: json["flagKey"] == null ? null : json["flagKey"],
        flagTags: json["flagTags"] == null
            ? null
            : List<String>.from(json["flagTags"].map((x) => x)),
        flagTagsOperator:
            json["flagTagsOperator"] == null ? null : json["flagTagsOperator"],
      );

  Map<String, dynamic> toJson() => {
        "entityID": entityId == null ? null : entityId,
        "entityType": entityType == null ? null : entityType,
        "entityContext": entityContext == null ? null : entityContext,
        "enableDebug": enableDebug == null ? null : enableDebug,
        "flagID": flagId == null ? null : flagId,
        "flagKey": flagKey == null ? null : flagKey,
        "flagTags": flagTags == null
            ? null
            : List<dynamic>.from(flagTags.map((x) => x)),
        "flagTagsOperator": flagTagsOperator == null ? null : flagTagsOperator,
      };
}
