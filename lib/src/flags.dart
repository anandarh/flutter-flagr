// To parse this JSON data, do
//
//     final flags = flagsFromJson(jsonString);

import 'dart:convert';

List<Flag> flagsFromJson(String str) =>
    List<Flag>.from(json.decode(str).map((x) => Flag.fromJson(x)));

String flagsToJson(List<Flag> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Flag {
  Flag({
    this.dataRecordsEnabled,
    this.description,
    this.enabled,
    this.id,
    this.key,
    this.segments,
    this.tags,
    this.updatedAt,
    this.variants,
  });

  final bool dataRecordsEnabled;
  final String description;
  final bool enabled;
  final int id;
  final String key;
  final List<dynamic> segments;
  final List<dynamic> tags;
  final DateTime updatedAt;
  final List<dynamic> variants;

  factory Flag.fromJson(Map<String, dynamic> json) => Flag(
        dataRecordsEnabled: json["dataRecordsEnabled"] == null
            ? null
            : json["dataRecordsEnabled"],
        description: json["description"] == null ? null : json["description"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        id: json["id"] == null ? null : json["id"],
        key: json["key"] == null ? null : json["key"],
        segments: json["segments"] == null
            ? null
            : List<dynamic>.from(json["segments"].map((x) => x)),
        tags: json["tags"] == null
            ? null
            : List<dynamic>.from(json["tags"].map((x) => x)),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        variants: json["variants"] == null
            ? null
            : List<dynamic>.from(json["variants"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "dataRecordsEnabled":
            dataRecordsEnabled == null ? null : dataRecordsEnabled,
        "description": description == null ? null : description,
        "enabled": enabled == null ? null : enabled,
        "id": id == null ? null : id,
        "key": key == null ? null : key,
        "segments": segments == null
            ? null
            : List<dynamic>.from(segments.map((x) => x)),
        "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "variants": variants == null
            ? null
            : List<dynamic>.from(variants.map((x) => x)),
      };
}
