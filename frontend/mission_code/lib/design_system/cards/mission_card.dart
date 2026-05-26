import 'package:flutter/material.dart';
import '../../theme/colors/app_colors.dart';

class MissionCard extends StatefulWidget {
  final Widget child;
  final Color? borderColor;
  final bool glow;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const MissionCard({
    super.key,
    required this.child,
    this.borderColor,
    this.glow = false,
    this.onTap,
    this.padding,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = widget.borderColor ?? AppColors.border;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surface400 : AppColors.surface600,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? (widget.borderColor ?? AppColors.neonGreen.withOpacity(0.4)) : effectiveBorder,
              width: 1,
            ),
            boxShadow: widget.glow || _hovered
                ? [BoxShadow(
                    color: (widget.borderColor ?? AppColors.neonGreen).withOpacity(0.12),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}