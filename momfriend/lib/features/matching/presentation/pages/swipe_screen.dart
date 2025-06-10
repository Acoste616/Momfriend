import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../../core/themes/mom_theme_colors.dart';
import '../../../../core/themes/mom_typography.dart';
import '../../../../shared/widgets/mom_button.dart';
import '../bloc/matching_bloc.dart';
import '../widgets/profile_card.dart';
import '../widgets/match_dialog.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late CardSwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    
    // Załaduj profile
    context.read<MatchingBloc>().add(const LoadPotentialMatches(userId: 'user123'));
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MomThemeColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MomFriend',
              style: MomTypography.logoText,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.favorite,
              color: MomThemeColors.primary,
              size: 20,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFiltersDialog();
            },
            tooltip: 'Filtry',
          ),
        ],
      ),
      body: BlocConsumer<MatchingBloc, MatchingState>(
        listener: (context, state) {
          if (state is MatchingMatched) {
            _showMatchDialog(state.matchedProfile);
          }
        },
        builder: (context, state) {
          if (state is MatchingLoading) {
            return _buildLoadingState();
          }
          
          if (state is MatchingError) {
            return _buildErrorState(state.message);
          }
          
          if (state is MatchingEmpty) {
            return _buildEmptyState(state.message);
          }
          
          if (state is MatchingLoaded) {
            return _buildSwipeCards(state);
          }
          
          if (state is MatchingMatched) {
            return _buildSwipeCards(MatchingLoaded(
              profiles: state.remainingProfiles,
              currentIndex: state.currentIndex,
            ));
          }
          
          return _buildInitialState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(MomThemeColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Szukam mam w Twojej okolicy... 🔍',
            style: MomTypography.body1.copyWith(
              color: MomThemeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: MomThemeColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: MomThemeColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ups! Coś poszło nie tak 😔',
              style: MomTypography.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: MomTypography.body1.copyWith(
                color: MomThemeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            MomButton(
              text: 'Spróbuj ponownie',
              onPressed: () {
                context.read<MatchingBloc>().add(
                  const LoadPotentialMatches(userId: 'user123'),
                );
              },
              leadingIcon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: MomThemeColors.primaryGradient.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration,
                size: 60,
                color: MomThemeColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Świetna robota! 🎉',
              style: MomTypography.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: MomTypography.body1.copyWith(
                color: MomThemeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            MomButton(
              text: 'Sprawdź nowe profile',
              onPressed: () {
                context.read<MatchingBloc>().add(
                  const LoadPotentialMatches(userId: 'user123'),
                );
              },
              leadingIcon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: MomThemeColors.primaryGradient.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 50,
                color: MomThemeColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Witaj w MomFriend! 💚',
              style: MomTypography.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Zacznij swipować, aby poznać nowe mamy z Twojej okolicy!',
              style: MomTypography.body1.copyWith(
                color: MomThemeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            MomButton(
              text: 'Rozpocznij wyszukiwanie',
              onPressed: () {
                context.read<MatchingBloc>().add(
                  const LoadPotentialMatches(userId: 'user123'),
                );
              },
              leadingIcon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeCards(MatchingLoaded state) {
    final profile = state.currentProfile;
    
    if (profile == null) {
      return _buildEmptyState('Nie ma więcej profili do pokazania');
    }

    return Column(
      children: [
        // Zachęcająca wiadomość
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: MomThemeColors.primaryGradient.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: MomThemeColors.primary.withOpacity(0.2),
            ),
          ),
          child: Text(
            'Poznaj mamy z okolicy! 💕',
            style: MomTypography.subtitle1.copyWith(
              color: MomThemeColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Główna karta profilu
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: 320,
                height: 500,
                child: Card(
                  elevation: 12,
                  shadowColor: MomThemeColors.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ProfileCard(
                      profile: profile,
                      swipeProgress: 0.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Informacje o postępie
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                size: 16,
                color: MomThemeColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Profil ${state.currentIndex + 1} z ${state.profiles.length}',
                style: MomTypography.caption,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Przyciski akcji
        _buildActionButtons(profile),
      ],
    );
  }

  Widget _buildActionButtons(profile) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Przycisk "Może innym razem"
          _buildActionButton(
            icon: Icons.close,
            color: MomThemeColors.pass,
            backgroundColor: MomThemeColors.surface,
            onPressed: () {
              context.read<MatchingBloc>().add(
                SwipeProfile(profileId: profile.id, action: SwipeAction.pass),
              );
            },
            tooltip: 'Może innym razem',
          ),
          
          // Przycisk "Super mama!"
          _buildActionButton(
            icon: Icons.star,
            color: MomThemeColors.superLike,
            backgroundColor: MomThemeColors.superLike.withOpacity(0.15),
            onPressed: () {
              context.read<MatchingBloc>().add(
                SuperLikeProfile(profileId: profile.id),
              );
            },
            tooltip: 'Super mama!',
            isLarge: true,
          ),
          
          // Przycisk "Chętnie poznam!"
          _buildActionButton(
            icon: Icons.favorite,
            color: MomThemeColors.like,
            backgroundColor: MomThemeColors.like.withOpacity(0.15),
            onPressed: () {
              context.read<MatchingBloc>().add(
                SwipeProfile(profileId: profile.id, action: SwipeAction.like),
              );
            },
            tooltip: 'Chętnie poznam!',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required String tooltip,
    bool isLarge = false,
  }) {
    final size = isLarge ? 70.0 : 60.0;
    final iconSize = isLarge ? 32.0 : 24.0;
    
    return Tooltip(
      message: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size / 2),
            child: Icon(
              icon,
              size: iconSize,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  void _showMatchDialog(profile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MatchDialog(profile: profile),
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.filter_list, color: MomThemeColors.primary),
            const SizedBox(width: 12),
            Text(
              'Filtry wyszukiwania',
              style: MomTypography.headline5,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Funkcja filtrów będzie dostępna wkrótce! 🚧',
              style: MomTypography.body1,
            ),
            const SizedBox(height: 16),
            Text(
              'Będziesz mogła filtrować mamy według:\n• Wieku dzieci\n• Odległości\n• Wspólnych zainteresowań',
              style: MomTypography.body2.copyWith(
                color: MomThemeColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          MomButton(
            text: 'OK',
            onPressed: () => Navigator.pop(context),
            type: MomButtonType.secondary,
            size: MomButtonSize.small,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
} 