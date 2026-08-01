import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceModel {
  final String id;
  final String motorcycleId;
  final String maintenanceType;
  final double cost;
  final String technician;
  final String status;
  final String notes;
  final Timestamp maintenanceDate;

  MaintenanceModel({
    required this.id,
    required this.motorcycleId,
    required this.maintenanceType,
    required this.cost,
    required this.technician,
    required this.status,
    required this.notes,
    required this.maintenanceDate,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json["id"] ?? "",
      motorcycleId: json["motorcycleId"] ?? "",
      maintenanceType: json["maintenanceType"] ?? "",
      cost: (json["cost"] as num).toDouble(),
      technician: json["technician"] ?? "",
      status: json["status"] ?? "Pending",
      notes: json["notes"] ?? "",
      maintenanceDate: json["maintenanceDate"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "motorcycleId": motorcycleId,
      "maintenanceType": maintenanceType,
      "cost": cost,
      "technician": technician,
      "status": status,
      "notes": notes,
      "maintenanceDate": maintenanceDate,
    };
  }
}