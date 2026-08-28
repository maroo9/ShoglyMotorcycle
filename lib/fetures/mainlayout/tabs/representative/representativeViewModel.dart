import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../Services/FirebaseServices.dart';

class RepresentativeViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String searchText = "";
  String? selectedMotorcycleId;
  String? recentlyReleasedMotorcycleId;
  bool isSaving = false;

  Stream<List<RepresentativeModel>> get representativesStream {
    return FirebaseServices.streamRepresentatives();
  }

  Stream<List<MotorcycleModel>> get motorcyclesStream {
    return FirebaseServices.streamMotorcycles();
  }

  List<MotorcycleModel> availableMotorcycles(
    List<MotorcycleModel> motorcycles,
    List<RepresentativeModel> representatives,
  ) {
    final rentedMotorcycleIds = representatives
        .where((representative) => representative.isActive)
        .map((representative) => representative.motorcycleId)
        .toSet();

    final availableMotors = motorcycles.where((motorcycle) {
      final status = motorcycle.status.toLowerCase();
      return !rentedMotorcycleIds.contains(motorcycle.id) &&
          !motorcycle.isRented &&
          status != "rented";
    }).toList();

    final uniqueMotors = <String, MotorcycleModel>{};
    for (final motorcycle in availableMotors) {
      uniqueMotors[motorcycle.id] = motorcycle;
    }

    final sortedMotors = uniqueMotors.values.toList();
    sortedMotors.sort((first, second) {
      if (first.id == recentlyReleasedMotorcycleId) return -1;
      if (second.id == recentlyReleasedMotorcycleId) return 1;
      return 0;
    });

    return sortedMotors;
  }

  void updateSearch(String value) {
    searchText = value.trim().toLowerCase();
    notifyListeners();
  }

  void selectMotorcycle(String? motorcycleId) {
    selectedMotorcycleId = motorcycleId;
    notifyListeners();
  }

  List<RepresentativeModel> filterRepresentatives(
    List<RepresentativeModel> representatives,
  ) {
    if (searchText.isEmpty) return representatives;

    return representatives.where((representative) {
      final searchableText = [
        representative.id,
        representative.name,
        representative.phone,
        representative.motorcycleId,
        representative.isActive ? "active" : "inactive",
      ].join(" ").toLowerCase();

      return searchableText.contains(searchText);
    }).toList();
  }

  Future<bool> addRepresentative(
    List<MotorcycleModel> motorcycles,
    List<RepresentativeModel> representatives,
  ) async {
    if (formKey.currentState?.validate() != true) return false;

    final availableMotors = availableMotorcycles(motorcycles, representatives);
    if (!_motorcycleIdExists(availableMotors)) return false;

    isSaving = true;
    notifyListeners();

    final representative = RepresentativeModel(
      id: "rep_${DateTime.now().microsecondsSinceEpoch}",
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      motorcycleId: selectedMotorcycleId!,
      rentalDate: DateTime.now(),
      isActive: true,
      createdAt: Timestamp.now(),
    );

    try {
      await FirebaseServices.addMotorRepresttiveTofirestore(representative);
      clearForm();
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRepresentative(RepresentativeModel representative) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();
      final representativeRef =
          firestore.collection("Representatives").doc(representative.id);
      final motorcycleRef =
          firestore.collection("Motors").doc(representative.motorcycleId);

      batch.delete(representativeRef);
      batch.update(motorcycleRef, {
        "isRented": false,
        "status": "Available",
        "representativeId": FieldValue.delete(),
      });

      await batch.commit();
      recentlyReleasedMotorcycleId = representative.motorcycleId;
      return true;
    } catch (_) {
      return false;
    }
  }

  String? requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "$label is required";
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
    nameController.clear();
    phoneController.clear();
    selectedMotorcycleId = null;
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
