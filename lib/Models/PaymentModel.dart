import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String motorcycleId;
  final String driverId;
  final double amount;
  final String paymentMethod;
  final Timestamp paymentDate;
  final String notes;

  PaymentModel({
    required this.id,
    required this.motorcycleId,
    required this.driverId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.notes,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"] ?? "",
      motorcycleId: json["motorcycleId"] ?? "",
      driverId: json["driverId"] ?? "",
      amount: (json["amount"] as num).toDouble(),
      paymentMethod: json["paymentMethod"] ?? "",
      paymentDate: json["paymentDate"] ?? Timestamp.now(),
      notes: json["notes"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "motorcycleId": motorcycleId,
      "driverId": driverId,
      "amount": amount,
      "paymentMethod": paymentMethod,
      "paymentDate": paymentDate,
      "notes": notes,
    };
  }
}