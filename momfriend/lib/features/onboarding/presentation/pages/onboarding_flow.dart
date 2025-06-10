import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/mom_theme_colors.dart';
import '../../../../core/themes/mom_typography.dart';
import '../../../../shared/widgets/mom_button.dart';

/// Kroki onboardingu zoptymalizowane dla matek
enum OnboardingStep {
  welcome,      // 20s - Ciepłe powitanie
  basicInfo,    // 45s - Imię, wiek
  children,     // 60s - Informacje o dzieciach (najważniejsze!)
  interests,    // 90s - Szybki wybór zainteresowań
  location,     // 30s - Lokalizacja (z wyjaśnieniem bezpieczeństwa)
  verification, // 45s - Weryfikacja (opcjonalna na starcie)
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  
  int _currentStep = 0;
  DateTime? _startTime;
  
  // Form data
  final _nameController = TextEditingController();
  int _selectedAge = 30;
  final List<ChildData> _children = [];
  final Set<String> _selectedInterests = {};
  bool _locationPermissionGranted = false;
  bool _skipVerification = true;

  final List<OnboardingStep> _steps = [
    OnboardingStep.welcome,
    OnboardingStep.basicInfo,
    OnboardingStep.children,
    OnboardingStep.interests,
    OnboardingStep.location,
    OnboardingStep.verification,
  ];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _updateProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final progress = (_currentStep + 1) / _steps.length;
    _progressAnimationController.animateTo(progress);
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _completeOnboarding() {
    final duration = DateTime.now().difference(_startTime!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    print('Onboarding completed in: ${minutes}m ${seconds}s');
    
    // TODO: Zapisz dane użytkownika
    Navigator.pushReplacementNamed(context, '/swipe');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    
    return Scaffold(
      backgroundColor: MomThemeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressBar(),
            
            // Main content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                itemBuilder: (context, index) => _buildStepWidget(_steps[index]),
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Krok ${_currentStep + 1} z ${_steps.length}',
                style: MomTypography.caption,
              ),
              Text(
                _getStepTitle(_steps[_currentStep]),
                style: MomTypography.subtitle2.copyWith(
                  color: MomThemeColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: MomThemeColors.surface,
                valueColor: const AlwaysStoppedAnimation(MomThemeColors.primary),
                minHeight: 6.h,
              );
            },
          ),
        ],
      ),
    );
  }

  String _getStepTitle(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return 'Witaj! 👋';
      case OnboardingStep.basicInfo:
        return 'O Tobie';
      case OnboardingStep.children:
        return 'Twoje dzieci 👶';
      case OnboardingStep.interests:
        return 'Zainteresowania 💕';
      case OnboardingStep.location:
        return 'Lokalizacja 📍';
      case OnboardingStep.verification:
        return 'Weryfikacja ✓';
    }
  }

  Widget _buildStepWidget(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return _buildWelcomeStep();
      case OnboardingStep.basicInfo:
        return _buildBasicInfoStep();
      case OnboardingStep.children:
        return _buildChildrenStep();
      case OnboardingStep.interests:
        return _buildInterestsStep();
      case OnboardingStep.location:
        return _buildLocationStep();
      case OnboardingStep.verification:
        return _buildVerificationStep();
    }
  }

  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              gradient: MomThemeColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: MomThemeColors.mediumShadow,
            ),
            child: Icon(
              Icons.favorite,
              size: 50.w,
              color: MomThemeColors.textOnColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Witaj w MomFriend! 💚',
            style: MomTypography.headline2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            'Poznawaj mamy z okolicy i twórz prawdziwe przyjaźnie',
            style: MomTypography.body1.copyWith(
              color: MomThemeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: MomThemeColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  color: MomThemeColors.primary,
                  size: 20.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Zajmie to tylko 3-4 minuty',
                    style: MomTypography.body2.copyWith(
                      color: MomThemeColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Jak masz na imię? 😊',
            style: MomTypography.headline3,
          ),
          SizedBox(height: 8.h),
          Text(
            'Używamy imion, żeby stworzyć przyjazną atmosferę',
            style: MomTypography.body2.copyWith(
              color: MomThemeColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: _nameController,
            style: MomTypography.inputText,
            decoration: InputDecoration(
              labelText: 'Twoje imię',
              hintText: 'np. Anna',
              prefixIcon: Icon(
                Icons.person,
                color: MomThemeColors.primary,
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          SizedBox(height: 24.h),
          Text(
            'Ile masz lat?',
            style: MomTypography.headline5,
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: MomThemeColors.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  '$_selectedAge lat',
                  style: MomTypography.headline4.copyWith(
                    color: MomThemeColors.primary,
                  ),
                ),
                Slider(
                  value: _selectedAge.toDouble(),
                  min: 18,
                  max: 50,
                  divisions: 32,
                  onChanged: (value) {
                    setState(() => _selectedAge = value.round());
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildChildrenStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Opowiedz o swoich dzieciach 👶',
            style: MomTypography.headline3,
          ),
          SizedBox(height: 8.h),
          Text(
            'Podaj inicjały i wiek - to pomoże znaleźć mamy w podobnej sytuacji',
            style: MomTypography.body2.copyWith(
              color: MomThemeColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          
          // Proste pola dla dzieci
          if (_children.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: MomThemeColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: MomThemeColors.primary.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.child_care,
                    size: 40.w,
                    color: MomThemeColors.primary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Dodaj swoje dziecko',
                    style: MomTypography.subtitle1.copyWith(
                      color: MomThemeColors.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Np. "A. 3 lata" lub "M. 5 lat"',
                    style: MomTypography.caption,
                  ),
                ],
              ),
            )
          else
            Column(
              children: _children.asMap().entries.map((entry) {
                int index = entry.key;
                ChildData child = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: MomThemeColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: MomThemeColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          gradient: MomThemeColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          child.gender == 'male' ? Icons.boy : Icons.girl,
                          color: MomThemeColors.textOnColor,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.name.isNotEmpty ? child.name : 'Dziecko',
                              style: MomTypography.subtitle1,
                            ),
                            Text(
                              '${child.ageYears} ${child.ageYears == 1 ? 'rok' : child.ageYears < 5 ? 'lata' : 'lat'}',
                              style: MomTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeChild(index),
                        icon: Icon(
                          Icons.delete_outline,
                          color: MomThemeColors.error,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          
          SizedBox(height: 20.h),
          MomButton(
            text: _children.isEmpty ? 'Dodaj dziecko' : 'Dodaj kolejne dziecko',
            onPressed: _addChild,
            type: MomButtonType.outline,
            leadingIcon: Icons.add,
          ),
          
          SizedBox(height: 20.h),
          
          // Opcja "Nie mam dzieci" lub "Pomiń"
          if (_children.isEmpty)
            MomButton(
              text: 'Nie mam jeszcze dzieci',
              onPressed: () => _nextStep(),
              type: MomButtonType.text,
              leadingIcon: Icons.people,
            ),
            
          SizedBox(height: 40.h), // Extra space for safe area
        ],
      ),
    );
  }

  Widget _buildInterestsStep() {
    final interests = [
      {'key': 'playground', 'label': 'Plac zabaw', 'icon': Icons.play_arrow},
      {'key': 'coffee', 'label': 'Kawa', 'icon': Icons.local_cafe},
      {'key': 'shopping', 'label': 'Zakupy', 'icon': Icons.shopping_bag},
      {'key': 'fitness', 'label': 'Fitness', 'icon': Icons.fitness_center},
      {'key': 'cooking', 'label': 'Gotowanie', 'icon': Icons.restaurant},
      {'key': 'reading', 'label': 'Czytanie', 'icon': Icons.menu_book},
      {'key': 'crafts', 'label': 'Rękodzieło', 'icon': Icons.palette},
      {'key': 'music', 'label': 'Muzyka', 'icon': Icons.music_note},
      {'key': 'outdoor', 'label': 'Na powietrzu', 'icon': Icons.nature},
      {'key': 'photography', 'label': 'Fotografia', 'icon': Icons.camera_alt},
      {'key': 'travel', 'label': 'Podróże', 'icon': Icons.flight},
      {'key': 'volunteering', 'label': 'Wolontariat', 'icon': Icons.volunteer_activism},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Co lubisz robić? 💕',
            style: MomTypography.headline3,
          ),
          SizedBox(height: 8.h),
          Text(
            'Wybierz co najmniej 3 zainteresowania',
            style: MomTypography.body2.copyWith(
              color: MomThemeColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 320.h, // Określona wysokość dla grid
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.5,
              ),
              itemCount: interests.length,
              itemBuilder: (context, index) {
                final interest = interests[index];
                final isSelected = _selectedInterests.contains(interest['key']);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest['key']);
                      } else {
                        _selectedInterests.add(interest['key'] as String);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MomThemeColors.primary.withOpacity(0.1)
                          : MomThemeColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? MomThemeColors.primary
                            : MomThemeColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          interest['icon'] as IconData,
                          color: isSelected
                              ? MomThemeColors.primary
                              : MomThemeColors.textSecondary,
                          size: 18.w,
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            interest['label'] as String,
                            style: MomTypography.body2.copyWith(
                              color: isSelected
                                  ? MomThemeColors.primary
                                  : MomThemeColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Lokalizacja 📍',
            style: MomTypography.headline3,
          ),
          SizedBox(height: 8.h),
          Text(
            'Potrzebujemy dostępu do lokalizacji, żeby pokazać Ci mamy w okolicy',
            style: MomTypography.body2.copyWith(
              color: MomThemeColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: MomThemeColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: MomThemeColors.info.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.security,
                  color: MomThemeColors.info,
                  size: 32.w,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Twoja prywatność jest dla nas najważniejsza',
                  style: MomTypography.subtitle1.copyWith(
                    color: MomThemeColors.info,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  '• Dokładna lokalizacja nigdy nie jest pokazywana\n• Pokazujemy tylko przybliżoną odległość\n• Możesz to zmienić w każdej chwili',
                  style: MomTypography.body2.copyWith(
                    color: MomThemeColors.info,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 120.h), // Spacer
          MomButton(
            text: _locationPermissionGranted
                ? 'Lokalizacja włączona ✓'
                : 'Włącz lokalizację',
            onPressed: _requestLocationPermission,
            leadingIcon: _locationPermissionGranted
                ? Icons.check_circle
                : Icons.location_on,
            customColor: _locationPermissionGranted
                ? MomThemeColors.success
                : null,
          ),
          SizedBox(height: 12.h),
          MomButton(
            text: 'Zrobię to później',
            onPressed: () {
              setState(() => _locationPermissionGranted = false);
              _nextStep();
            },
            type: MomButtonType.text,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildVerificationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Weryfikacja profilu ✓',
            style: MomTypography.headline3,
          ),
          SizedBox(height: 8.h),
          Text(
            'Zweryfikowane profile budują większe zaufanie',
            style: MomTypography.body2.copyWith(
              color: MomThemeColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: MomThemeColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.verified_user,
                  color: MomThemeColors.verified,
                  size: 48.w,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Weryfikacja obejmuje:',
                  style: MomTypography.subtitle1,
                ),
                SizedBox(height: 12.h),
                Text(
                  '• Zdjęcie selfie (sprawdzenie tożsamości)\n• Numer telefonu\n• Profil w mediach społecznościowych (opcjonalnie)',
                  style: MomTypography.body2.copyWith(
                    color: MomThemeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100.h), // Spacer
          MomButton(
            text: 'Zweryfikuj teraz',
            onPressed: () {
              setState(() => _skipVerification = false);
              _completeOnboarding();
            },
            leadingIcon: Icons.verified,
            customColor: MomThemeColors.verified,
          ),
          SizedBox(height: 12.h),
          MomButton(
            text: 'Pomiń na razie',
            onPressed: () {
              setState(() => _skipVerification = true);
              _completeOnboarding();
            },
            type: MomButtonType.outline,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canGoNext = _canProceedToNextStep();
    
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: MomButton(
                text: 'Wstecz',
                onPressed: _previousStep,
                type: MomButtonType.outline,
                leadingIcon: Icons.arrow_back,
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: MomButton(
              text: _currentStep == _steps.length - 1 ? 'Zakończ' : 'Dalej',
              onPressed: canGoNext ? _nextStep : null,
              trailingIcon: _currentStep < _steps.length - 1 
                  ? Icons.arrow_forward 
                  : Icons.check,
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceedToNextStep() {
    switch (_steps[_currentStep]) {
      case OnboardingStep.welcome:
        return true;
      case OnboardingStep.basicInfo:
        return _nameController.text.isNotEmpty;
      case OnboardingStep.children:
        return true; // Dzieci są opcjonalne - można nie mieć lub jeszcze nie dodać
      case OnboardingStep.interests:
        return _selectedInterests.length >= 3;
      case OnboardingStep.location:
        return true; // Lokalizacja jest opcjonalna
      case OnboardingStep.verification:
        return true; // Weryfikacja jest opcjonalna
    }
  }

  void _addChild() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddChildBottomSheet(
        onAdd: (child) {
          setState(() => _children.add(child));
        },
      ),
    );
  }

  void _removeChild(int index) {
    setState(() => _children.removeAt(index));
  }

  void _requestLocationPermission() async {
    // TODO: Implementuj rzeczywiste żądanie uprawnień
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _locationPermissionGranted = true);
  }
}

// Klasa dla danych dziecka
class ChildData {
  final int ageYears;
  final String gender;
  final String name;

  ChildData({required this.ageYears, required this.gender, this.name = ''});
}

// Bottom sheet dla dodawania dziecka
class _AddChildBottomSheet extends StatefulWidget {
  final Function(ChildData) onAdd;

  const _AddChildBottomSheet({required this.onAdd});

  @override
  State<_AddChildBottomSheet> createState() => _AddChildBottomSheetState();
}

class _AddChildBottomSheetState extends State<_AddChildBottomSheet> {
  int _selectedAge = 3;
  String _selectedGender = 'female';
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MomThemeColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: MomThemeColors.surface,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Dodaj dziecko',
            style: MomTypography.headline4,
          ),
          SizedBox(height: 24.h),
          
          // Pole na inicjały/imię
          TextField(
            controller: _nameController,
            style: MomTypography.inputText,
            decoration: InputDecoration(
              labelText: 'Inicjały lub imię',
              hintText: 'np. A., Ania, M.',
              prefixIcon: Icon(
                Icons.child_care,
                color: MomThemeColors.primary,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          
          // Wiek
          Text(
            'Wiek: $_selectedAge ${_selectedAge == 1 ? 'rok' : _selectedAge < 5 ? 'lata' : 'lat'}',
            style: MomTypography.subtitle1,
          ),
          SizedBox(height: 8.h),
          Slider(
            value: _selectedAge.toDouble(),
            min: 0,
            max: 18,
            divisions: 18,
            onChanged: (value) => setState(() => _selectedAge = value.round()),
          ),
          SizedBox(height: 24.h),
          
          // Płeć
          Text(
            'Płeć',
            style: MomTypography.subtitle1,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedGender = 'female'),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: _selectedGender == 'female'
                          ? MomThemeColors.primary.withOpacity(0.1)
                          : MomThemeColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: _selectedGender == 'female'
                            ? MomThemeColors.primary
                            : MomThemeColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.girl,
                          color: _selectedGender == 'female'
                              ? MomThemeColors.primary
                              : MomThemeColors.textSecondary,
                          size: 24.w,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Dziewczynka',
                          style: MomTypography.body2.copyWith(
                            color: _selectedGender == 'female'
                                ? MomThemeColors.primary
                                : MomThemeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedGender = 'male'),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: _selectedGender == 'male'
                          ? MomThemeColors.primary.withOpacity(0.1)
                          : MomThemeColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: _selectedGender == 'male'
                            ? MomThemeColors.primary
                            : MomThemeColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.boy,
                          color: _selectedGender == 'male'
                              ? MomThemeColors.primary
                              : MomThemeColors.textSecondary,
                          size: 24.w,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Chłopiec',
                          style: MomTypography.body2.copyWith(
                            color: _selectedGender == 'male'
                                ? MomThemeColors.primary
                                : MomThemeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          MomButton(
            text: 'Dodaj',
            onPressed: () {
              widget.onAdd(ChildData(
                ageYears: _selectedAge,
                gender: _selectedGender,
                name: _nameController.text.trim(),
              ));
              Navigator.pop(context);
            },
            leadingIcon: Icons.add,
          ),
        ],
      ),
    );
  }
} 