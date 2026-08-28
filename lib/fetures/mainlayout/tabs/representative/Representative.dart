import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../l10n/app_localizations.dart';
import 'RepresentativeCard.dart';
import 'RepresentativeInput.dart';
import '_RaisedEndFloatLocation.dart';
import 'representativeViewModel.dart';

class Representative extends StatefulWidget {
  const Representative({super.key});

  @override
  State<Representative> createState() => _RepresentativeState();
}

class _RepresentativeState extends State<Representative> {
  late final RepresentativeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RepresentativeViewModel();
    viewModel.addListener(_refreshUi);
  }

  @override
  void dispose() {
    viewModel.removeListener(_refreshUi);
    viewModel.dispose();
    super.dispose();
  }

  void _refreshUi() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.bg,
      appBar: AppBar(
        backgroundColor: Colorsmanger.darkblue,
        foregroundColor: Colorsmanger.White,
        title:  Text( AppLocalizations.of(context)!.representative),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colorsmanger.darkblue,
        foregroundColor: Colorsmanger.White,
        onPressed: _showAddRepresentativeSheet,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: const RaisedEndFloatLocation(),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(20),
            child: TextField(
              controller: viewModel.searchController,
              onChanged: viewModel.updateSearch,
              decoration: InputDecoration(
                hintText:  AppLocalizations.of(context)!.search_motorcycle_hint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colorsmanger.White,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<RepresentativeModel>>(
              stream: viewModel.representativesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return  Center(
                    child: Text(AppLocalizations.of(context)!.could_not_load_representatives),
                  );
                }

                final representatives =
                    viewModel.filterRepresentatives(snapshot.data ?? []);

                if (representatives.isEmpty) {
                  return  Center(child: Text(AppLocalizations.of(context)!.no_representatives_found));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  itemBuilder: (context, index) {
                    return RepresentativeCard(
                      representative: representatives[index],
                      onDelete: () => _deleteRepresentative(
                        representatives[index],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: representatives.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRepresentativeSheet() {
    viewModel.clearForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colorsmanger.White,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StreamBuilder<List<RepresentativeModel>>(
          stream: viewModel.representativesStream,
          builder: (context, representativesSnapshot) {
            return StreamBuilder<List<MotorcycleModel>>(
              stream: viewModel.motorcyclesStream,
              builder: (context, snapshot) {
                final motorcycles = snapshot.data ?? [];
                final representatives = representativesSnapshot.data ?? [];
                final availableMotorcycles = viewModel.availableMotorcycles(
                  motorcycles,
                  representatives,
                );
                final selectedMotorcycleMatches = availableMotorcycles.where(
                  (motorcycle) =>
                      motorcycle.id == viewModel.selectedMotorcycleId,
                );
                final selectedMotorcycleId =
                    selectedMotorcycleMatches.length == 1
                        ? viewModel.selectedMotorcycleId
                        : null;

                return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: viewModel.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                           Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.representative,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RepresentativeInput(
                        controller: viewModel.nameController,
                        label:  AppLocalizations.of(context)!.representative_name,
                        icon: Icons.person,
                        validator: viewModel.requiredValidator,
                      ),
                      const SizedBox(height: 12),
                      RepresentativeInput(
                        controller: viewModel.phoneController,
                        label: AppLocalizations.of(context)!.phone,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: viewModel.requiredValidator,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedMotorcycleId,
                        validator: viewModel.motorcycleValidator,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.motorcycle_id_code,
                          prefixIcon: const Icon(Icons.motorcycle),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: availableMotorcycles.map((motorcycle) {
                          return DropdownMenuItem(
                            value: motorcycle.id,
                            child: Text(
                              "${motorcycle.id} - ${motorcycle.licenseNumber}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: viewModel.selectMotorcycle,
                      ),
                      const SizedBox(height: 18),
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          representativesSnapshot.connectionState ==
                              ConnectionState.waiting)
                        const Center(child: CircularProgressIndicator())
                      else if (motorcycles.isEmpty)
                         Text(
                           AppLocalizations.of(context)!.add_motorcycle_first,
                          textAlign: TextAlign.center,
                        )
                      else if (availableMotorcycles.isEmpty)
                        const Text(
                          "All motorcycles are already rented.",
                          textAlign: TextAlign.center,
                        )
                      else if (viewModel.isSaving)
                        const Center(child: CircularProgressIndicator())
                      else
                        CustomElevatedButton(
                          text:  AppLocalizations.of(context)!.save,
                          onPress: () => _saveRepresentative(
                            motorcycles,
                            representatives,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _saveRepresentative(
    List<MotorcycleModel> motorcycles,
    List<RepresentativeModel> representatives,
  ) async {
    final isAdded = await viewModel.addRepresentative(
      motorcycles,
      representatives,
    );
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded
              ? "Representative added successfully"
              : "Failed to add representative",
        ),
      ),
    );

    if (isAdded) {
      Navigator.pop(context);
    }
  }

  Future<void> _deleteRepresentative(
    RepresentativeModel representative,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete representative"),
          content: Text("Delete ${representative.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final isDeleted = await viewModel.deleteRepresentative(representative);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDeleted
              ? "Representative deleted successfully"
              : "Failed to delete representative",
        ),
      ),
    );
  }
}
