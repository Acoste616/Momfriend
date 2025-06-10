import 'package:flutter/material.dart';
import '../../core/themes/mom_theme_colors.dart';
import '../../core/themes/mom_typography.dart';

/// Typy przycisków dostosowane do różnych sytuacji w aplikacji
enum MomButtonType {
  /// Główny przycisk akcji - z gradientem primary
  primary,
  /// Drugorzędny przycisk - delikatny outline
  secondary,
  /// Przycisk z obramowaniem - dla opcji alternatywnych
  outline,
  /// Przycisk tekstowy - dla akcji mniej istotnych
  text,
}

/// Rozmiary przycisków
enum MomButtonSize {
  small,
  medium,
  large,
}

/// Przycisk dostosowany do potrzeb matek
/// Ciepły design z zaokrąglonymi kształtami i przyjazną kolorystyką
class MomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final MomButtonType type;
  final MomButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? customColor;
  final double? customRadius;

  const MomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = MomButtonType.primary,
    this.size = MomButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.customColor,
    this.customRadius,
  });

  @override
  State<MomButton> createState() => _MomButtonState();
}

class _MomButtonState extends State<MomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          gradient: _getGradient(),
          border: _getBorder(),
          boxShadow: _getShadow(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            onTap: widget.isLoading ? null : widget.onPressed,
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: () => _handleTapUp(),
            child: Container(
              padding: _getPadding(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: widget.isFullWidth 
                    ? MainAxisSize.max 
                    : MainAxisSize.min,
                children: [
                  if (widget.leadingIcon != null && !widget.isLoading) ...[
                    Icon(
                      widget.leadingIcon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                    SizedBox(width: _getIconSpacing()),
                  ],
                  
                  if (widget.isLoading)
                    SizedBox(
                      width: _getLoadingSize(),
                      height: _getLoadingSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(_getTextColor()),
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        widget.text,
                        style: _getTextStyle(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  if (widget.trailingIcon != null && !widget.isLoading) ...[
                    SizedBox(width: _getIconSpacing()),
                    Icon(
                      widget.trailingIcon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapDown() {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  double _getBorderRadius() {
    return widget.customRadius ?? 16.0;
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case MomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case MomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case MomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case MomButtonSize.small:
        return 16;
      case MomButtonSize.medium:
        return 20;
      case MomButtonSize.large:
        return 24;
    }
  }

  double _getIconSpacing() {
    switch (widget.size) {
      case MomButtonSize.small:
        return 6;
      case MomButtonSize.medium:
        return 8;
      case MomButtonSize.large:
        return 12;
    }
  }

  double _getLoadingSize() {
    switch (widget.size) {
      case MomButtonSize.small:
        return 16;
      case MomButtonSize.medium:
        return 20;
      case MomButtonSize.large:
        return 24;
    }
  }

  LinearGradient? _getGradient() {
    if (widget.customColor != null) {
      return LinearGradient(
        colors: [widget.customColor!, widget.customColor!.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    switch (widget.type) {
      case MomButtonType.primary:
        return MomThemeColors.primaryGradient;
      case MomButtonType.secondary:
        return MomThemeColors.secondaryGradient;
      case MomButtonType.outline:
      case MomButtonType.text:
        return null;
    }
  }

  Border? _getBorder() {
    switch (widget.type) {
      case MomButtonType.outline:
        return Border.all(
          color: widget.customColor ?? MomThemeColors.primary,
          width: 2,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    if (widget.type == MomButtonType.text) return null;
    
    return [
      BoxShadow(
        color: _getShadowColor().withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  Color _getShadowColor() {
    switch (widget.type) {
      case MomButtonType.primary:
        return widget.customColor ?? MomThemeColors.primary;
      case MomButtonType.secondary:
        return MomThemeColors.secondary;
      default:
        return Colors.black;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case MomButtonType.primary:
      case MomButtonType.secondary:
        return MomThemeColors.textOnColor;
      case MomButtonType.outline:
        return widget.customColor ?? MomThemeColors.primary;
      case MomButtonType.text:
        return widget.customColor ?? MomThemeColors.primary;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = widget.size == MomButtonSize.small 
        ? MomTypography.buttonTextSmall 
        : MomTypography.buttonText;

    return baseStyle.copyWith(color: _getTextColor());
  }
}

/// Specjalizowane przyciski dla różnych akcji w aplikacji

/// Przycisk "Like" dla systemu swipe
class LikeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LikeButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MomButton(
      text: 'Chętnie poznam! 💚',
      onPressed: onPressed,
      isLoading: isLoading,
      customColor: MomThemeColors.like,
      leadingIcon: Icons.favorite,
    );
  }
}

/// Przycisk "Pass" dla systemu swipe
class PassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const PassButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MomButton(
      text: 'Może innym razem',
      onPressed: onPressed,
      isLoading: isLoading,
      type: MomButtonType.outline,
      customColor: MomThemeColors.pass,
      leadingIcon: Icons.close,
    );
  }
}

/// Przycisk "Super Like" dla systemu swipe
class SuperLikeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SuperLikeButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MomButton(
      text: 'Super mama! ⭐',
      onPressed: onPressed,
      isLoading: isLoading,
      customColor: MomThemeColors.superLike,
      leadingIcon: Icons.star,
      size: MomButtonSize.large,
    );
  }
} 