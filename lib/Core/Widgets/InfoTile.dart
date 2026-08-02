import 'package:flutter/cupertino.dart';

import '../ColorsManger/Colorsmanger.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colorsmanger.Grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
