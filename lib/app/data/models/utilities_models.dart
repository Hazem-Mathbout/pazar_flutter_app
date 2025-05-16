class Make {
  final int id;
  final String name;
  final Map<String, String> label;

  Make({
    required this.id,
    required this.name,
    required this.label,
  });

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
      id: json['id'],
      name: json['name'] ?? '',
      label: Map<String, String>.from(json['label'] ?? {}),
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
      label: {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Make && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
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
  final Map<String, String> name;

  BodyType({
    required this.key,
    required this.name,
  });

  factory BodyType.fromJson(Map<String, dynamic> json) {
    return BodyType(
      key: json['key'] ?? '',
      name: Map<String, String>.from(json['name'] ?? {}),
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
  final Map<String, String> name;

  Province({
    required this.key,
    required this.name,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      key: json['key'] ?? '',
      name: Map<String, String>.from(json['name'] ?? {}),
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
  final Map<String, String> title;
  final String slug;
  final Map<String, String>
      body; // Adjust if you later define structure for `body`

  PageItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.body,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) {
    return PageItem(
      id: json['id'] ?? 0,
      title: Map<String, String>.from(json['title'] ?? {}),
      slug: json['slug'] ?? '',
      body: Map<String, String>.from(json['body'] ?? {}),
    );
  }
}
