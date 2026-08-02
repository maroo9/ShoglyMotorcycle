import 'package:cloud_firestore/cloud_firestore.dart';

class RepresentativeModel {
  final String id;

  final String name;
  final String phone;

  final String motorcycleId;

  final DateTime rentalDate;

  final bool isActive;

  final Timestamp createdAt;

  RepresentativeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.motorcycleId,
    required this.rentalDate,
    required this.isActive,
    required this.createdAt,
  });

  factory RepresentativeModel.fromJson(Map<String, dynamic> json) {
    return RepresentativeModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      motorcycleId: json["motorcycleId"] ?? "",
      rentalDate: json["rentalDate"] is Timestamp
          ? (json["rentalDate"] as Timestamp).toDate()
          : DateTime.now(),
      isActive: json["isActive"] ?? true,
      createdAt: json["createdAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "motorcycleId": motorcycleId,
      "rentalDate": Timestamp.fromDate(rentalDate),
      "isActive": isActive,
      "createdAt": createdAt,
    };
  }

}
