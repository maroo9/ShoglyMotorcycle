import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';

class TotalMoneyCard extends StatelessWidget {
  const TotalMoneyCard({
    required this.total,
    required this.dateText,
    required this.isToday,
    required this.onReset,
  });

  final double total;
  final String dateText;
  final bool isToday;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colorsmanger.darkblue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? "Total collected today" : "Total collected on $dateText",
                  style: const TextStyle(
                    color: Colorsmanger.Whiteblue,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${total.toStringAsFixed(2)} EGP",
                  style: const TextStyle(
                    color: Colorsmanger.White,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orangeAccent,
              side: const BorderSide(color: Colors.orangeAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt, size: 18),
            label: const Text("Reset Day"),
          ),
        ],
      ),
    );
  }
}
