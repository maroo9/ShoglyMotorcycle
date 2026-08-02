import 'package:flutter/cupertino.dart';

import '../ColorsManger/Colorsmanger.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colorsmanger.Whiteblue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colorsmanger.darkblue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}