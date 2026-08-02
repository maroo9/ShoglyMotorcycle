import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../Models/MaintenanceModel.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Services/FirebaseServices.dart';

class MaintanceViewModel extends ChangeNotifier {
  final TextEditingController costController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController neededWorkController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedMotorcycleId;
  String maintenanceType = "Oil Change";
  String status = "Pending";
  bool isSaving = false;

  final List<String> maintenanceTypes = const [
    "Oil Change",
    "Tires",
    "Brake Service",
    "Engine Repair",
    "General Service",
  ];

  final List<String> statuses = const [
    "Pending",
    "Completed",
  ];

  Stream<List<MotorcycleModel>> get motorcyclesStream {
    return FirebaseServices.streamMotorcycles();
  }

  Stream<List<MaintenanceModel>> get maintenanceStream {
    return FirebaseServices.streamMaintenance();
  }

  List<MotorcycleModel> uniqueMotorcycles(List<MotorcycleModel> motorcycles) {
    final uniqueMotors = <String, MotorcycleModel>{};
    for (final motorcycle in motorcycles) {
      uniqueMotors[motorcycle.id] = motorcycle;
    }
    return uniqueMotors.values.toList();
  }

  MaintenanceModel? maintenanceForMotorcycle(
    MotorcycleModel motorcycle,
    List<MaintenanceModel> maintenances,
  ) {
    for (final maintenance in maintenances) {
      if (maintenance.motorcycleId == motorcycle.id) {
        return maintenance;
      }
    }
    return null;
  }

  void prepareForm({
    MotorcycleModel? motorcycle,
    MaintenanceModel? maintenance,
  }) {
    selectedMotorcycleId = motorcycle?.id ?? maintenance?.motorcycleId;
    maintenanceType = maintenance?.maintenanceType.isNotEmpty == true
        ? maintenance!.maintenanceType
        : "Oil Change";
    status = maintenance?.status.isNotEmpty == true
        ? maintenance!.status
        : "Pending";
    costController.text = maintenance == null ? "" : maintenance.cost.toString();
    notesController.text = maintenance?.notes ?? "";
    neededWorkController.text = maintenance?.technician ?? "";
    notifyListeners();
  }

  void selectMotorcycle(String? motorcycleId) {
    selectedMotorcycleId = motorcycleId;
    notifyListeners();
  }

  void selectMaintenanceType(String? type) {
    if (type == null) return;
    maintenanceType = type;
    notifyListeners();
  }

  void selectStatus(String? newStatus) {
    if (newStatus == null) return;
    status = newStatus;
    notifyListeners();
  }

  Future<bool> saveMaintenance(List<MotorcycleModel> motorcycles) async {
    if (formKey.currentState?.validate() != true) return false;
    if (!_motorcycleIdExists(motorcycles)) return false;

    isSaving = true;
    notifyListeners();

    final maintenance = MaintenanceModel(
      id: selectedMotorcycleId!,
      motorcycleId: selectedMotorcycleId!,
      maintenanceType: maintenanceType,
      cost: double.tryParse(costController.text.trim()) ?? 0,
      technician: neededWorkController.text.trim(),
      status: status,
      notes: notesController.text.trim(),
      maintenanceDate: Timestamp.now(),
    );

    try {
      await FirebaseServices.addMentanceTofirestore(maintenance);
      clearForm();
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  String? requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "$label is required";
    }
    return null;
  }

  String? costValidator(String? value) {
    final cost = double.tryParse(value?.trim() ?? "");
    if (cost == null || cost < 0) {
      return "Enter a valid amount";
    }
    return null;
  }

  String? motorcycleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Motorcycle id is required";
    }
    return null;
  }

  bool _motorcycleIdExists(List<MotorcycleModel> motorcycles) {
    return motorcycles.any((motorcycle) => motorcycle.id == selectedMotorcycleId);
  }

  void clearForm() {
    selectedMotorcycleId = null;
    maintenanceType = "Oil Change";
    status = "Pending";
    costController.clear();
    notesController.clear();
    neededWorkController.clear();
  }

  @override
  void dispose() {
    costController.dispose();
    notesController.dispose();
    neededWorkController.dispose();
    super.dispose();
  }
}
