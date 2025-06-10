import 'package:flutter/material.dart';
import '../../../../core/themes/mom_theme_colors.dart';
import '../../../../core/themes/mom_typography.dart';
import '../../../../shared/widgets/mom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MomThemeColors.background,
              Color(0xFFFFF0F0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo i nazwa aplikacji
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: MomThemeColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: MomThemeColors.mediumShadow,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Nazwa aplikacji
                      Text(
                        'MomFriend',
                        style: MomTypography.logoText.copyWith(fontSize: 36),
                      ),
                      const SizedBox(height: 16),
                      
                      // Tagline
                      Text(
                        'Znajdź swoje mamskie tribe 💚',
                        style: MomTypography.headline3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Opis
                      Text(
                        'Bezpieczna przestrzeń dla mam, gdzie nawiązujesz prawdziwe przyjaźnie i dzielisz się radościami macierzyństwa',
                        style: MomTypography.body1.copyWith(
                          color: MomThemeColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Sekcja z benefitami
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildBenefitItem(
                        context,
                        '🤗',
                        'Poznaj mamy z okolicy',
                        'Znajdź koleżanki mieszkające blisko Ciebie',
                      ),
                      const SizedBox(height: 16),
                      _buildBenefitItem(
                        context,
                        '👶',
                        'Organizuj wspólne aktywności',
                        'Playdates, spacery, kawka w parku',
                      ),
                      const SizedBox(height: 16),
                      _buildBenefitItem(
                        context,
                        '💬',
                        'Wymieniaj się doświadczeniami',
                        'Wspieraj się nawzajem w macierzyństwie',
                      ),
                    ],
                  ),
                ),
                
                // Przyciski akcji
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MomButton(
                        text: 'Rozpocznij znajomości! 💚',
                        onPressed: () {
                          Navigator.pushNamed(context, '/onboarding');
                        },
                      ),
                      const SizedBox(height: 16),
                      MomButton(
                        text: 'Mam już konto',
                        onPressed: () {
                          // Przejdź bezpośrednio do swipowania (symulacja logowania)
                          Navigator.pushNamed(context, '/swipe');
                        },
                        type: MomButtonType.outline,
                      ),
                      const SizedBox(height: 24),
                      
                      // Disclaimer
                      Text(
                        'Tworząc konto, akceptujesz nasze Warunki Korzystania\ni Politykę Prywatności',
                        style: MomTypography.caption.copyWith(
                          color: MomThemeColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    String emoji,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MomThemeColors.primary.withOpacity(0.2),
        ),
        boxShadow: MomThemeColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: MomThemeColors.accentGradient.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: MomTypography.subtitle1,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: MomTypography.body2.copyWith(
                    color: MomThemeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 