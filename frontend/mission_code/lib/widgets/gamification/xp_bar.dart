import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/colors/app_colors.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final String label;
  final bool animated;

  const XpBar({
    super.key,
    required this.currentXp,
    required this.maxXp,
    this.label = 'XP',
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentXp / maxXp).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              '$currentXp / $maxXp',
              style: const TextStyle(
                color: AppColors.neonGreen,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 8,
            color: AppColors.xpTrack,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: animated ? const Duration(milliseconds: 1200) : Duration.zero,
                      curve: Curves.easeOutCubic,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.neonGreen, Color(0xFF4ADE80)],
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonGreen.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}