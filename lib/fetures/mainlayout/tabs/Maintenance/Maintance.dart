import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/CustomTextForm.dart';
import '../../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/MaintenanceModel.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../l10n/app_localizations.dart';
import '../representative/_RaisedEndFloatLocation.dart';
import 'MaintanceViewModel.dart';
import '_MaintenanceMotorcycleCard.dart';

class Maintance extends StatefulWidget {
  const Maintance({super.key});

  @override
  State<Maintance> createState() => _MaintanceState();
}

class _MaintanceState extends State<Maintance> {
  late final MaintanceViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MaintanceViewModel();
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
        title: Text(AppLocalizations.of(context)!.maintenance),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colorsmanger.darkblue,
        foregroundColor: Colorsmanger.White,
        onPressed: () => _showMaintenanceSheet(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: const RaisedEndFloatLocation(),
      body: StreamBuilder<List<MaintenanceModel>>(
        stream: viewModel.maintenanceStream,
        builder: (context, maintenanceSnapshot) {
          final maintenances = maintenanceSnapshot.data ?? [];

          return StreamBuilder<List<MotorcycleModel>>(
            stream: viewModel.motorcyclesStream,
            builder: (context, motorcycleSnapshot) {
              if (maintenanceSnapshot.connectionState ==
                      ConnectionState.waiting ||
                  motorcycleSnapshot.connectionState ==
                      ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (maintenanceSnapshot.hasError || motorcycleSnapshot.hasError) {
                return const Center(child: Text("Could not load maintenance"));
              }

              final motorcycles =
                  viewModel.uniqueMotorcycles(motorcycleSnapshot.data ?? []);

              if (motorcycles.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.no_motorcycles),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                itemBuilder: (context, index) {
                  final motorcycle = motorcycles[index];
                  final maintenance = viewModel.maintenanceForMotorcycle(
                    motorcycle,
                    maintenances,
                  );

                  return MaintenanceMotorcycleCard(
                    motorcycle: motorcycle,
                    maintenance: maintenance,
                    onEdit: () => _showMaintenanceSheet(
                      motorcycle: motorcycle,
                      maintenance: maintenance,
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: motorcycles.length,
              );
            },
          );
        },
      ),
    );
  }

  void _showMaintenanceSheet({
    MotorcycleModel? motorcycle,
    MaintenanceModel? maintenance,
  }) {
    viewModel.prepareForm(
      motorcycle: motorcycle,
      maintenance: maintenance,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colorsmanger.White,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return StreamBuilder<List<MotorcycleModel>>(
              stream: viewModel.motorcyclesStream,
              builder: (context, snapshot) {
                final motorcycles =
                    viewModel.uniqueMotorcycles(snapshot.data ?? []);
                final selectedMatches = motorcycles.where(
                  (motorcycle) =>
                      motorcycle.id == viewModel.selectedMotorcycleId,
                );
                final selectedMotorcycleId =
                    selectedMatches.length == 1
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
                              const Expanded(
                                child: Text(
                                  "Maintenance",
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
                          DropdownButtonFormField<String>(
                            value: selectedMotorcycleId,
                            validator: viewModel.motorcycleValidator,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: "Motorcycle id / code",
                              prefixIcon: const Icon(Icons.motorcycle),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: motorcycles.map((motorcycle) {
                              return DropdownMenuItem(
                                value: motorcycle.id,
                                child: Text(
                                  "${motorcycle.id} - ${motorcycle.licenseNumber}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              viewModel.selectMotorcycle(value);
                              setSheetState(() {});
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: viewModel.maintenanceType,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: "Maintenance type",
                              prefixIcon: const Icon(Icons.build),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: viewModel.maintenanceTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              viewModel.selectMaintenanceType(value);
                              setSheetState(() {});
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextForm(
                            controller: viewModel.neededWorkController,
                            labelText: "What it needs",
                            prefixIcon: Icons.handyman,
                            validator: (value) =>
                                viewModel.requiredValidator(value, "Needed work"),
                          ),
                          const SizedBox(height: 12),
                          CustomTextForm(
                            controller: viewModel.costController,
                            labelText: "Amount",
                            prefixIcon: Icons.payments,
                            keyboardType: TextInputType.number,
                            validator: viewModel.costValidator,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: viewModel.status,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: "Status",
                              prefixIcon: const Icon(Icons.flag),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: viewModel.statuses.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              viewModel.selectStatus(value);
                              setSheetState(() {});
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextForm(
                            controller: viewModel.notesController,
                            labelText: "Notes",
                            prefixIcon: Icons.notes,
                            validator: (_) => null,
                            Lines: 2,
                          ),
                          const SizedBox(height: 18),
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            const Center(child: CircularProgressIndicator())
                          else if (motorcycles.isEmpty)
                            Text(
                              AppLocalizations.of(context)!
                                  .add_motorcycle_first,
                              textAlign: TextAlign.center,
                            )
                          else if (viewModel.isSaving)
                            const Center(child: CircularProgressIndicator())
                          else
                            CustomElevatedButton(
                              text: AppLocalizations.of(context)!.save,
                              onPress: () => _saveMaintenance(motorcycles),
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

  Future<void> _saveMaintenance(List<MotorcycleModel> motorcycles) async {
    final isSaved = await viewModel.saveMaintenance(motorcycles);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved
              ? "Maintenance saved successfully"
              : "Failed to save maintenance",
        ),
      ),
    );

    if (isSaved) {
      Navigator.pop(context);
    }
  }
}

