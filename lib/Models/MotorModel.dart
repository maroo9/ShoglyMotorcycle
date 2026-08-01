import 'package:cloud_firestore/cloud_firestore.dart';

class MotorcycleModel {
  final String id;
  final String name;
  final String model;
  final String licenseNumber;
  final String ownerId;
  final String? driverId;
  final String imageUrl;
  final String status;
  final Timestamp createdAt;

  MotorcycleModel({
    required this.id,
    required this.name,
    required this.model,
    required this.licenseNumber,
    required this.ownerId,
    this.driverId,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory MotorcycleModel.fromJson(Map<String, dynamic> json) {
    return MotorcycleModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      model: json["model"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      ownerId: json["ownerId"] ?? "",
      driverId: json["driverId"],
      imageUrl: json["imageUrl"] ?? "",
      status: json["status"] ?? "Available",
      createdAt: json["createdAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "model": model,
      "licenseNumber": licenseNumber,
      "ownerId": ownerId,
      "driverId": driverId,
      "imageUrl": imageUrl,
      "status": status,
      "createdAt": createdAt,
    };
  }


}