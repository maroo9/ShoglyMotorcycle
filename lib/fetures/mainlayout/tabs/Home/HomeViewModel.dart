import 'package:flutter/material.dart';

import '../../../../Models/MaintenanceModel.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/PaymentModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../Services/FirebaseServices.dart';

class HomeViewModel extends ChangeNotifier {
  Stream<List<MotorcycleModel>> get motorcyclesStream {
    return FirebaseServices.streamMotorcycles();
  }

  Stream<List<RepresentativeModel>> get representativesStream {
    return FirebaseServices.streamRepresentatives();
  }

  Stream<List<PaymentModel>> get paymentsStream {
    return FirebaseServices.streamPayments();
  }

  Stream<List<MaintenanceModel>> get maintenanceStream {
    return FirebaseServices.streamMaintenance();
  }

  double totalCollected(List<PaymentModel> payments, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    return payments
        .where((payment) => payment.isPaid && payment.isSameDay(targetDate))
        .fold(0, (total, payment) => total + payment.amount);
  }

  int rentedMotorcycles(
    List<MotorcycleModel> motorcycles,
    List<RepresentativeModel> representatives,
  ) {
    final activeMotorIds = representatives
        .where((representative) => representative.isActive)
        .map((representative) => representative.motorcycleId)
        .toSet();

    return motorcycles.where((motorcycle) {
      return motorcycle.isRented ||
          motorcycle.status.toLowerCase() == "rented" ||
          activeMotorIds.contains(motorcycle.id);
    }).length;
  }

  int availableMotorcycles(
    List<MotorcycleModel> motorcycles,
    List<RepresentativeModel> representatives,
  ) {
    return motorcycles.length - rentedMotorcycles(motorcycles, representatives);
  }

  int pendingMaintenance(List<MaintenanceModel> maintenances) {
    return maintenances
        .where((maintenance) => maintenance.status.toLowerCase() != "completed")
        .length;
  }

  int completedMaintenance(List<MaintenanceModel> maintenances) {
    return maintenances
        .where((maintenance) => maintenance.status.toLowerCase() == "completed")
        .length;
  }

  int pendingPayments(List<PaymentModel> payments, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    return payments
        .where((payment) => !payment.isPaid && payment.isSameDay(targetDate))
        .length;
  }
}
