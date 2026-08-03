import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/PaymentModel.dart';
import '../../../../Models/representativeModel.dart';

class PaymentRepresentativeCard extends StatelessWidget {
  const PaymentRepresentativeCard({
    required this.representative,
    required this.payment,
    required this.onEdit,
  });

  final RepresentativeModel representative;
  final PaymentModel? payment;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final isPaid = payment?.isPaid ?? false;
    final amount = payment?.amount ?? 0;
    final method = payment?.paymentMethod ?? "Not selected";

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
                StatusChip(status: isPaid ? "Paid" : "Not paid"),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoRow(icon: Icons.motorcycle, text: representative.motorcycleId),
            const SizedBox(height: 6),
            InfoRow(
              icon: Icons.payments,
              text: "${amount.toStringAsFixed(2)} EGP",
            ),
            const SizedBox(height: 6),
            InfoRow(icon: Icons.account_balance_wallet, text: method),
            const SizedBox(height: 6),
            InfoRow(
              icon: Icons.calendar_month,
              text:
              "${representative.rentalDate.year}-${representative.rentalDate.month}-${representative.rentalDate.day}",
            ),
          ],
        ),
      ),
    );
  }
}
