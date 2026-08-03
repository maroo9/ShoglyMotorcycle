import 'package:cloud_firestore/cloud_firestore.dart';
class MotorcycleModel {
  final String id;
  final String name;
  final String model;
  final String licenseNumber;
  final String color;
  final String ownerId;
  final String ownerPhone;
  final String? driverId;
  final String imageUrl;
  final String status;
  final Timestamp createdAt;
  final String? representativeId;
  final bool isRented;

  MotorcycleModel({
    required this.id,
    required this.name,
    required this.model,
    required this.licenseNumber,
    required this.color,
    required this.ownerId,
    this.ownerPhone = "",
    this.driverId,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    this.representativeId,
    this.isRented = false,
  });

  factory MotorcycleModel.fromJson(Map<String, dynamic> json) {
    return MotorcycleModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      model: json["model"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      color: json["color"] ?? "",
      ownerId: json["ownerId"] ?? "",
      ownerPhone: json["ownerPhone"] ?? "",
      driverId: json["driverId"],
      imageUrl: json["imageUrl"] ?? "",
      status: json["status"] ?? "Available",
      createdAt: json["createdAt"] ?? Timestamp.now(),
      representativeId: json["representativeId"],
      isRented: json["isRented"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "model": model,
      "licenseNumber": licenseNumber,
      "color": color,
      "ownerId": ownerId,
      "ownerPhone": ownerPhone,
      "driverId": driverId,
      "imageUrl": imageUrl,
      "status": status,
      "createdAt": createdAt,
      "representativeId": representativeId,
      "isRented": isRented,
    };
  }
}
