import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/themes/app_theme.dart';
import 'features/matching/presentation/bloc/matching_bloc.dart';
import 'features/matching/presentation/pages/swipe_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_flow.dart';
import 'features/auth/presentation/pages/welcome_screen.dart';

void main() {
  runApp(const MomFriendApp());
}

class MomFriendApp extends StatelessWidget {
  const MomFriendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MatchingBloc()),
          ],
          child: MaterialApp(
            title: 'MomFriend - Znajdź mamy w okolicy',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: const WelcomeScreen(), // Zacznij od welcome screen
            routes: {
              '/welcome': (context) => const WelcomeScreen(),
              '/onboarding': (context) => const OnboardingFlow(),
              '/swipe': (context) => const SwipeScreen(),
            },
          ),
        );
      },
    );
  }
} 