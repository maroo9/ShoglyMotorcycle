
import 'package:flutter/material.dart';
import 'package:shoghly/l10n/app_localizations.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/representativeModel.dart';

class RepresentativeCard extends StatelessWidget {
  const RepresentativeCard({
    required this.representative,
    required this.onDelete,
  });

  final RepresentativeModel representative;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        representative.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        representative.phone,
                        style: const TextStyle(color: Colorsmanger.Grey),
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  status: representative.isActive ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.inactive,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colorsmanger.Red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.motorcycle,
              text: representative.motorcycleId,
            ),

            const SizedBox(height: 6),
            InfoRow(
              icon: Icons.calendar_month,
              text:
              AppLocalizations.of(context)!.representative_start_date+ " ${representative!.rentalDate.year}-${representative!.rentalDate.month}-${representative!.rentalDate.day}",
            ),

          ],
        ),
      ),
    );
  }
}
