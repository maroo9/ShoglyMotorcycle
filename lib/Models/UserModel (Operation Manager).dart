import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? profileImage;
  final Timestamp createdAt;

  static UserModel? currentUser;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.profileImage,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"],
      role: json["role"] ?? "operationManager",
      profileImage: json["profileImage"],
      createdAt: json["createdAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "profileImage": profileImage,
      "createdAt": createdAt,
    };
  }


}