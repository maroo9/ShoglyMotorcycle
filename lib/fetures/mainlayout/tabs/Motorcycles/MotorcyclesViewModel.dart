import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoghly/Core/routesMnager/RoutesManger.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../Services/FirebaseServices.dart';

class MotorcyclesViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String searchText = "";
  bool isSaving = false;
  FloatingActionButtonLocation fabLocation =
      FloatingActionButtonLocation.endFloat;

  Stream<List<MotorcycleModel>> get motorcyclesStream {
    return FirebaseServices.streamMotorcycles();
  }

  Stream<List<RepresentativeModel>> get representativesStream {
    return FirebaseServices.streamRepresentatives();
  }

  RepresentativeModel? activeRepresentativeForMotorcycle(
    MotorcycleModel motorcycle,
    List<RepresentativeModel> representatives,
  ) {
    for (final representative in representatives) {
      if (representative.isActive &&
          representative.motorcycleId == motorcycle.id) {
        return representative;
      }
    }
    return null;
  }

  void updateSearch(String value) {
    searchText = value.trim().toLowerCase();
    notifyListeners();
  }

  void updateFabLocation(FloatingActionButtonLocation location) {
    fabLocation = location;
    notifyListeners();
  }

  List<MotorcycleModel> filterMotorcycles(List<MotorcycleModel> motorcycles) {
    if (searchText.isEmpty) return motorcycles;

    return motorcycles.where((motorcycle) {
      final searchableText = [
        motorcycle.id,
        motorcycle.name,
        motorcycle.model,
        motorcycle.licenseNumber,
        motorcycle.color,
        motorcycle.ownerId,
        motorcycle.ownerPhone,
        motorcycle.status,
      ].join(" ").toLowerCase();

      return searchableText.contains(searchText);
    }).toList();
  }

  Future<bool> addMotorcycle() async {
    if (formKey.currentState?.validate() != true) return false;

    isSaving = true;
    notifyListeners();

    final motorcycle = MotorcycleModel(
      id: "motor_${DateTime.now().microsecondsSinceEpoch}",
      name: nameController.text.trim(),
      model: modelController.text.trim(),
      licenseNumber: licenseController.text.trim(),
      color: colorController.text.trim(),
      ownerId: ownerController.text.trim(),
      ownerPhone: ownerPhoneController.text.trim(),
      driverId: null,
      imageUrl: "",
      status: "Available",
      createdAt: Timestamp.now(),
    );

    try {
      await FirebaseServices.addMotorCyclesTofirestore(motorcycle);
      clearForm();
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> logout() {
    return FirebaseServices.logout();
  }

  String? requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "$label is required";
    }
    return null;
  }

  void clearForm() {
    nameController.clear();
    modelController.clear();
    licenseController.clear();
    colorController.clear();
    ownerController.clear();
    ownerPhoneController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    modelController.dispose();
    licenseController.dispose();
    colorController.dispose();
    ownerController.dispose();
    ownerPhoneController.dispose();
    super.dispose();
  }


}
