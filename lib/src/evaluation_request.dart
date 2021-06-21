class Evaluation {
  Evaluation({
    this.entityId,
    this.entityType,
    this.entityContext,
    this.enableDebug,
    this.flagId,
    this.flagKey,
    this.flagTags,
    this.flagTagsOperator,
  })  : assert(flagId < 1, 'FlagId must be greater than or equal to 1'),
        assert((flagId == null) && (flagKey == null),
            'Both FlagId and FlagKey cannot be null, one must be filled');

  final String entityId;
  final String entityType;
  final dynamic entityContext;
  final bool enableDebug;
  final int flagId;
  final String flagKey;
  final List<String> flagTags;
  final String flagTagsOperator;
}
