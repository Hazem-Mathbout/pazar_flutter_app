import 'package:pazar/app/data/models/advertisement_model.dart';

class Make {
  final int id;
  final String name;
  final LocalizedText label;

  Make({
    required this.id,
    required this.name,
    required this.label,
  });

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
      id: json['id'],
      name: json['name'] ?? '',
      label: LocalizedText.fromJson(json['label'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
    };
  }

  static Make empty() {
    return Make(
      id: -1,
      name: '',
      label: LocalizedText(ar: '', en: ''),
    );
  }

  /// Creates a new instance with updated fields (null-safe).
  Make copyWith({
    int? id,
    String? name,
    LocalizedText? label,
  }) {
    return Make(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Make && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "(id: $id, name: $name, label: $label)";
  }
}

class ColorItem {
  final String key;
  final Map<String, String> name;
  final String hex;

  ColorItem({
    required this.key,
    required this.name,
    required this.hex,
  });

  // Add this empty factory constructor
  factory ColorItem.empty() {
    return ColorItem(
      key: '',
      name: {'ar': 'غير محدد'}, // Arabic default text
      hex: '',
    );
  }

  factory ColorItem.fromJson(Map<String, dynamic> json) {
    return ColorItem(
      key: json['key'] ?? '',
      name: Map<String, String>.from(json['name'] ?? {}),
      hex: json['hex'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorItem && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

class BodyType {
  final String key;
  final LocalizedText name;

  BodyType({
    required this.key,
    required this.name,
  });

  factory BodyType.fromJson(Map<String, dynamic> json) {
    return BodyType(
      key: json['key'] ?? '',
      name: LocalizedText.fromJson(json['name'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BodyType && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

class Province {
  final String key;
  final LocalizedText name;

  Province({
    required this.key,
    required this.name,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      key: json['key'] ?? '',
      name: LocalizedText.fromJson(json['name'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Province && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

class PageItem {
  final int id;
  final LocalizedText title;
  final String slug;
  final LocalizedText body;

  PageItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.body,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) {
    return PageItem(
      id: json['id'] ?? 0,
      title: LocalizedText.fromJson(json['title'] ?? {}),
      slug: json['slug'] ?? '',
      body: LocalizedText.fromJson(json['body'] ?? {}),
    );
  }
}

class RegionalSpecs {
  final String key;
  final LocalizedText label;

  RegionalSpecs({
    required this.key,
    required this.label,
  });

  factory RegionalSpecs.fromJson(Map<String, dynamic> json) {
    return RegionalSpecs(
      key: json['key'] ?? '',
      label: LocalizedText.fromJson(json['label'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegionalSpecs && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
