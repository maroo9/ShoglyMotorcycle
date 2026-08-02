import 'package:flutter/material.dart';

import '../../../../../Core/ColorsManger/Colorsmanger.dart';

class HomeShortcuts extends StatelessWidget {
  const HomeShortcuts({super.key, required this.items});

  final List<HomeShortcutItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: item.onTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colorsmanger.White,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colorsmanger.lightgrey),
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colorsmanger.darkblue,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colorsmanger.Grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colorsmanger.Grey),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class HomeShortcutItem {
  const HomeShortcutItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
