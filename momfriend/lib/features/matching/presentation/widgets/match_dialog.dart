import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/entities/mom_profile.dart';
import '../../../../core/themes/mom_theme_colors.dart';
import '../../../../core/themes/mom_typography.dart';
import '../../../../shared/widgets/mom_button.dart';

class MatchDialog extends StatefulWidget {
  final MomProfile profile;

  const MatchDialog({
    super.key,
    required this.profile,
  });

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Uruchom animacje
    _scaleController.forward();
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: MomThemeColors.background,
            borderRadius: BorderRadius.circular(24),
            boxShadow: MomThemeColors.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Konfetti i nagłówek
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // Zdjęcie matched profilu
              _buildProfileImage(),
              
              const SizedBox(height: 20),
              
              // Informacje o matchu
              _buildMatchInfo(),
              
              const SizedBox(height: 24),
              
              // Przyciski akcji
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Ikona celebracji z animacją
        AnimatedBuilder(
          animation: _confettiController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _confettiController.value * 2 * 3.14159,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: MomThemeColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: MomThemeColors.mediumShadow,
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Tytuł
        Text(
          'To match! 🎉',
          style: MomTypography.matchTitle,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Podtytuł
        Text(
          'Wy dwie się spodoba się! Teraz możecie zacząć rozmawiać.',
          style: MomTypography.body1.copyWith(
            color: MomThemeColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: MomThemeColors.mediumShadow,
        border: Border.all(
          color: MomThemeColors.primary,
          width: 4,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.profile.primaryPhotoUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: MomThemeColors.surface,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MomThemeColors.primary),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: MomThemeColors.surface,
            child: Icon(
              Icons.person,
              size: 60,
              color: MomThemeColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MomThemeColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MomThemeColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Imię i wiek
          Text(
            '${widget.profile.name}, ${widget.profile.age}',
            style: MomTypography.headline4.copyWith(
              color: MomThemeColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Informacje o dzieciach
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.child_care,
                size: 16,
                color: MomThemeColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.profile.childrenInfo,
                style: MomTypography.body2.copyWith(
                  color: MomThemeColors.textSecondary,
                ),
              ),
            ],
          ),
          
          // Odległość (jeśli dostępna)
          if (widget.profile.distanceKm != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: MomThemeColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.profile.distanceFormatted} stąd',
                  style: MomTypography.body2.copyWith(
                    color: MomThemeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          
          // Wspólne zainteresowania (pierwszych kilka)
          if (widget.profile.interests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Wspólne zainteresowania:',
              style: MomTypography.caption.copyWith(
                color: MomThemeColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              alignment: WrapAlignment.center,
              children: widget.profile.interestLabels.take(3).map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MomThemeColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MomThemeColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    interest,
                    style: MomTypography.caption.copyWith(
                      color: MomThemeColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Główny przycisk - napisz wiadomość
        MomButton(
          text: 'Napisz wiadomość 💬',
          onPressed: () {
            Navigator.of(context).pop();
            // TODO: Przejdź do chatu
            _navigateToChat();
          },
          leadingIcon: Icons.chat_bubble,
        ),
        
        const SizedBox(height: 12),
        
        // Przycisk drugorzędny - kontynuuj swipowanie
        MomButton(
          text: 'Kontynuuj przeglądanie',
          onPressed: () {
            Navigator.of(context).pop();
          },
          type: MomButtonType.outline,
          trailingIcon: Icons.arrow_forward,
        ),
        
        const SizedBox(height: 8),
        
        // Opcja przeglądania profilu
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showFullProfile();
          },
          child: Text(
            'Zobacz pełny profil',
            style: MomTypography.body2.copyWith(
              color: MomThemeColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToChat() {
    // TODO: Implementuj nawigację do chatu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chat z ${widget.profile.name} zostanie wkrótce zaimplementowany! 💬',
          style: MomTypography.body2.copyWith(color: Colors.white),
        ),
        backgroundColor: MomThemeColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFullProfile() {
    // TODO: Implementuj pełny widok profilu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pełny profil ${widget.profile.name} zostanie wkrótce zaimplementowany! 👀',
          style: MomTypography.body2.copyWith(color: Colors.white),
        ),
        backgroundColor: MomThemeColors.info,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 