import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/colors/app_colors.dart';

enum MissionButtonVariant { primary, secondary, danger, ghost, outline }

class MissionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final MissionButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;
  final double? height;

  const MissionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MissionButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
    this.height,
  });

  @override
  State<MissionButton> createState() => _MissionButtonState();
}

class _MissionButtonState extends State<MissionButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  Color get _bgColor => switch (widget.variant) {
    MissionButtonVariant.primary   => AppColors.neonGreen,
    MissionButtonVariant.secondary => AppColors.neonBlue,
    MissionButtonVariant.danger    => AppColors.danger,
    MissionButtonVariant.ghost     => Colors.transparent,
    MissionButtonVariant.outline   => Colors.transparent,
  };

  Color get _textColor => switch (widget.variant) {
    MissionButtonVariant.primary   => AppColors.bg800,
    MissionButtonVariant.secondary => AppColors.bg800,
    MissionButtonVariant.danger    => Colors.white,
    MissionButtonVariant.ghost     => AppColors.textSecondary,
    MissionButtonVariant.outline   => AppColors.neonGreen,
  };

  Border? get _border => switch (widget.variant) {
    MissionButtonVariant.outline => Border.all(color: AppColors.neonGreen, width: 1.5),
    MissionButtonVariant.ghost   => Border.all(color: AppColors.border, width: 1),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit:  (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.loading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: widget.height ?? 48,
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: _bgColor.withOpacity(_isHovered ? 0.85 : 1.0),
            borderRadius: BorderRadius.circular(12),
            border: _border,
            boxShadow: _isHovered && widget.variant == MissionButtonVariant.primary
                ? [BoxShadow(color: AppColors.greenGlow, blurRadius: 16, spreadRadius: 2)]
                : null,
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.loading)
                SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _textColor,
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: _textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate(target: _isHovered ? 1 : 0)
     .scale(end: const Offset(1.02, 1.02), duration: 120.ms);
  }
}