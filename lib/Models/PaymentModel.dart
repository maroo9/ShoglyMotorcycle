import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String representativeId;
  final String motorcycleId;
  final String driverId;
  final double amount;
  final String paymentMethod;
  final bool isPaid;
  final Timestamp paymentDate;
  final String notes;

  PaymentModel({
    required this.id,
    required this.representativeId,
    required this.motorcycleId,
    required this.driverId,
    required this.amount,
    required this.paymentMethod,
    required this.isPaid,
    required this.paymentDate,
    required this.notes,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"] ?? "",
      representativeId: json["representativeId"] ?? json["driverId"] ?? "",
      motorcycleId: json["motorcycleId"] ?? "",
      driverId: json["driverId"] ?? "",
      amount: json["amount"] is num ? (json["amount"] as num).toDouble() : 0,
      paymentMethod: json["paymentMethod"] ?? "",
      isPaid: json["isPaid"] ?? false,
      paymentDate: json["paymentDate"] ?? Timestamp.now(),
      notes: json["notes"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "representativeId": representativeId,
      "motorcycleId": motorcycleId,
      "driverId": driverId,
      "amount": amount,
      "paymentMethod": paymentMethod,
      "isPaid": isPaid,
      "paymentDate": paymentDate,
      "notes": notes,
    };
  }
}
