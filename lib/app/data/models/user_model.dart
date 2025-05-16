import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String whatsappNumber;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.whatsappNumber,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      profileImageUrl: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'whatsapp_number': whatsappNumber,
        'profile_image': profileImageUrl,
      };

  static UserModel? fromRawJson(String? str) {
    if (str == null) return null;
    return UserModel.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  @override
  String toString() {
    return 'email: $email\nname: $name\nwhatsapp number: $whatsappNumber\nphoto: $profileImageUrl';
  }
}
