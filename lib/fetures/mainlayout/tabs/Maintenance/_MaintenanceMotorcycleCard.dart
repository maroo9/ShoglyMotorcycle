import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoghly/l10n/app_localizations.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/MaintenanceModel.dart';
import '../../../../Models/MotorcycleModel.dart';

class MaintenanceMotorcycleCard extends StatelessWidget {
  const MaintenanceMotorcycleCard({
    required this.motorcycle,
    required this.maintenance,
    required this.onEdit,
  });

  final MotorcycleModel motorcycle;
  final MaintenanceModel? maintenance;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final status = maintenance?.status ?? AppLocalizations.of(context)!.no_maintenance;
    final cost = maintenance?.cost ?? 0;

    return Card(
      color: Colorsmanger.White,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colorsmanger.lightgrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.motorcycle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        motorcycle.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        motorcycle.licenseNumber,
                        style: const TextStyle(color: Colorsmanger.Grey),
                      ),
                    ],
                  ),
                ),
                StatusChip(status: status),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoRow(icon: Icons.tag, text: motorcycle.id),
            const SizedBox(height: 6),
            InfoRow(icon: Icons.description, text: motorcycle.model),
            const SizedBox(height: 6),
            InfoRow(icon: Icons.palette, text: motorcycle.color),
            const SizedBox(height: 6),
            InfoRow(icon: Icons.person, text: motorcycle.ownerId),
            if (maintenance != null) ...[
              const SizedBox(height: 10),
              InfoRow(
                icon: Icons.build,
                text: maintenance!.maintenanceType.isEmpty
                    ? AppLocalizations.of(context)!.maintenance_type
                    : maintenance!.maintenanceType,
              ),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.handyman,
                text: maintenance!.technician.isEmpty
                    ? AppLocalizations.of(context)!.technician_name
                    : maintenance!.technician,
              ),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.payments,
                text: "${cost.toStringAsFixed(2)} EGP",
              ),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.notes,
                text: maintenance!.notes.isEmpty ? "No notes" : maintenance!.notes,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
