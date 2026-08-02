import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/CustomTextForm.dart';
import '../../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../../Core/Widgets/Custom_Text_Button.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Core/routesMnager/RoutesManger.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../Services/FirebaseServices.dart';
import '../../../../l10n/app_localizations.dart';
import '../representative/_RaisedEndFloatLocation.dart';
import 'MotorcycleCard.dart';
import 'MotorcycleInput.dart';
import 'MotorcyclesViewModel.dart';

class Motorcycles extends StatefulWidget {
  const Motorcycles({super.key});

  @override
  State<Motorcycles> createState() => _MotorcyclesState();
}

class _MotorcyclesState extends State<Motorcycles> {
  late final MotorcyclesViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MotorcyclesViewModel();
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
        title:  Text(AppLocalizations.of(context)!.motorcycles),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colorsmanger.darkblue,
        foregroundColor: Colorsmanger.White,
        onPressed: _showAddMotorcycleSheet,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: const RaisedEndFloatLocation(),
      body: Column(
        children: [
SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: viewModel.searchController,
              onChanged: viewModel.updateSearch,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search_motorcycle_hint,
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
              builder: (context, representativesSnapshot) {
                return StreamBuilder<List<MotorcycleModel>>(
                  stream: viewModel.motorcyclesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        representativesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                    if (snapshot.hasError || representativesSnapshot.hasError) {
                  return  Center(
                    child: Text(AppLocalizations.of(context)!.could_not_load_motorcycles),
                  );
                }

                final motorcycles =
                    viewModel.filterMotorcycles(snapshot.data ?? []);
                    final representatives =
                        representativesSnapshot.data ?? [];

                if (motorcycles.isEmpty) {
                  return  Center(child: Text(AppLocalizations.of(context)!.no_motorcycles));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  itemBuilder: (context, index) {
                        final motorcycle = motorcycles[index];
                        return MotorcycleCard(
                          motorcycle: motorcycle,
                          representative:
                              viewModel.activeRepresentativeForMotorcycle(
                            motorcycle,
                            representatives,
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
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    ElevatedButton(
      onPressed: () async {
        await FirebaseServices.logout();
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          RoutesManager.Logins,
        );
      },
      child: Text(AppLocalizations.of(context)!.logout,
          style: GoogleFonts.dmSerifDisplay(fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colorsmanger.darkblue)
      ),
    );
  }


  void _showAddMotorcycleSheet() {
    viewModel.clearForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colorsmanger.White,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
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
                          AppLocalizations.of(context)!.add_motorcycle,
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
                  MotorcycleInput(
                    controller: viewModel.nameController,
                    label: AppLocalizations.of(context)!.motorcycle_name,
                    icon: Icons.motorcycle,
                    validator: viewModel.requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  MotorcycleInput(
                    controller: viewModel.modelController,
                    label:  AppLocalizations.of(context)!.motorcycle_model,
                    icon: Icons.description,
                    validator: viewModel.requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  MotorcycleInput(
                    controller: viewModel.licenseController,
                    label:  AppLocalizations.of(context)!.license_number,
                    icon: Icons.confirmation_number,
                    validator: viewModel.requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  MotorcycleInput(
                    controller: viewModel.colorController,
                    label:  AppLocalizations.of(context)!.color,
                    icon: Icons.palette,
                    validator: viewModel.requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  MotorcycleInput(
                    controller: viewModel.ownerController,
                    label:  AppLocalizations.of(context)!.owner_name,
                    icon: Icons.person,
                    validator: viewModel.requiredValidator,
                  ),
                  const SizedBox(height: 18),
                  viewModel.isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : CustomElevatedButton(
                          text:  AppLocalizations.of(context)!.save_motorcycle,
                          onPress: _saveMotorcycle,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveMotorcycle() async {
    final isAdded = await viewModel.addMotorcycle();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded
              ? "Motorcycle added successfully"
              : "Failed to add motorcycle",
        ),
      ),
    );

    if (isAdded) {
      Navigator.pop(context);
    }
  }
}



