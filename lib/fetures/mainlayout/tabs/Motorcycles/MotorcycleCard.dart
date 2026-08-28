import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../l10n/app_localizations.dart';

class MotorcycleCard extends StatelessWidget {
  const MotorcycleCard({
    required this.motorcycle,
    this.representative,
    required this.onEdit,
  });

  final MotorcycleModel motorcycle;
  final RepresentativeModel? representative;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final subscriptionRenewalDate = DateFormat(
      'EEEE M-d-yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(motorcycle.subscriptionRenewalDate.toDate());

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
                StatusChip(
                  status: representative == null
                      ? AppLocalizations.of(context)!.available
                      : AppLocalizations.of(context)!.rented,
                ),
                IconButton(
                  tooltip: "Edit motorcycle",
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
            InfoRow(
              icon: Icons.person,
              text: AppLocalizations.of(context)!.owner_name +
                  ": ${motorcycle.ownerId}",
            ),
            const SizedBox(height: 6),
            InfoRow(
              icon: Icons.calendar_today,
              text: AppLocalizations.of(context)!.subscription_renewal_date +
                  ": ${subscriptionRenewalDate}",
            ),
            if (motorcycle.ownerPhone.isNotEmpty) ...[
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.phone,
                text: AppLocalizations.of(context)!.owner_phone +
                    " ${motorcycle.ownerPhone}",
              ),
            ],
            if (representative != null) ...[
              const SizedBox(height: 6),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.phone,
                text: AppLocalizations.of(context)!.representative_phone +
                    "${representative!.phone}",
              ),
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}
