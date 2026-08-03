import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import 'PaymentsViewModel.dart';

class DateSelectorBar extends StatelessWidget {
  const DateSelectorBar({
    required this.viewModel,
    required this.onPickDate,
  });

  final PaymentsViewModel viewModel;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${viewModel.selectedDate.year}-${viewModel.selectedDate.month.toString().padLeft(2, '0')}-${viewModel.selectedDate.day.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colorsmanger.White,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => viewModel.changeDateByDays(-1),
          ),
          InkWell(
            onTap: onPickDate,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month,
                      color: Colorsmanger.darkblue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colorsmanger.darkblue,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colorsmanger.darkblue),
                ],
              ),
            ),
          ),
          Row(
            children: [
              if (!viewModel.isSelectedDateToday)
                TextButton(
                  onPressed: viewModel.selectToday,
                  child: const Text(
                    "Today",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: () => viewModel.changeDateByDays(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}