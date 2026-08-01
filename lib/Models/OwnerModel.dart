import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerModel {
  final String id;
  final String name;
  final String phone;


  OwnerModel({
    required this.id,
    required this.name,
    required this.phone,

  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,

    };
  }

 
}