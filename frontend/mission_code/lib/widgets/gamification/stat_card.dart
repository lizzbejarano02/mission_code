import 'package:flutter/material.dart';
import '../../theme/colors/app_colors.dart';
import '../../design_system/cards/mission_card.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return MissionCard(
      borderColor: color.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              if (subtitle != null)
                Text(subtitle!, style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600,
                )),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(
            color: AppColors.textMuted, fontSize: 12,
          )),
        ],
      ),
    );
  }
}