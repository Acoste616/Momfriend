import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/entities/mom_profile.dart';
import '../../../../core/themes/mom_theme_colors.dart';
import '../../../../core/themes/mom_typography.dart';

class ProfileCard extends StatelessWidget {
  final MomProfile profile;
  final double swipeProgress;

  const ProfileCard({
    super.key,
    required this.profile,
    this.swipeProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: MomThemeColors.mediumShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Główne zdjęcie profilu
            _buildMainImage(),
            
            // Gradient overlay dla czytelności tekstu
            _buildGradientOverlay(),
            
            // Informacje o profilu na dole
            _buildProfileInfo(),
            
            // Status online
            _buildOnlineStatus(),
            
            // Ikona weryfikacji
            _buildVerificationBadge(),
            
            // Swipe indicator
            if (swipeProgress != 0.0) _buildSwipeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImage() {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: profile.primaryPhotoUrl,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 80,
                color: MomThemeColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Zdjęcie niedostępne',
                style: MomTypography.body2.copyWith(
                  color: MomThemeColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Color(0x66000000),
              Color(0xAA000000),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imię i wiek
          Row(
            children: [
              Expanded(
                child: Text(
                  '${profile.name}, ${profile.age}',
                  style: MomTypography.profileName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (profile.distanceKm != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.distanceFormatted,
                        style: MomTypography.caption.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Informacje o dzieciach
          Text(
            profile.childrenInfo,
            style: MomTypography.profileDetails,
          ),
          
          const SizedBox(height: 8),
          
          // Bio (jeśli istnieje)
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            Text(
              profile.bio!,
              style: MomTypography.profileDetails.copyWith(
                fontSize: 14,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          
          // Zainteresowania (pierwsze 3)
          if (profile.interests.isNotEmpty)
            _buildInterestChips(),
        ],
      ),
    );
  }

  Widget _buildInterestChips() {
    final displayInterests = profile.interestLabels.take(3).toList();
    
    return Wrap(
      spacing: 6,
      children: displayInterests.map((interest) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: MomThemeColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MomThemeColors.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            interest,
            style: MomTypography.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOnlineStatus() {
    if (!profile.isOnline) return const SizedBox.shrink();
    
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: MomThemeColors.success,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Online',
              style: MomTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    if (!profile.isVerified) return const SizedBox.shrink();
    
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: MomThemeColors.verified,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.verified,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    final isLike = swipeProgress > 0;
    final color = isLike ? MomThemeColors.like : MomThemeColors.pass;
    final icon = isLike ? Icons.favorite : Icons.close;
    final text = isLike ? 'PODOBA CI SIĘ' : 'MOŻE INNYM RAZEM';
    
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: MomThemeColors.mediumShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: MomTypography.buttonText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 