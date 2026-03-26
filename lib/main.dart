import 'package:flutter/material.dart';
import 'data/onboarding_repository.dart';
import 'domain/onboarding_usecase.dart';
import 'presentation/onboarding_screen.dart';
import 'presentation/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboardingUseCase = OnboardingUseCase(
    repository: OnboardingRepository(),
  );
  final isFirstTime = await onboardingUseCase.isFirstTime();

  runApp(
    TravelTalkApp(
      startWithOnboarding: isFirstTime,
      onboardingUseCase: onboardingUseCase,
    ),
  );
}

class TravelTalkApp extends StatelessWidget {
  final bool startWithOnboarding;
  final OnboardingUseCase onboardingUseCase;

  const TravelTalkApp({
    super.key,
    required this.startWithOnboarding,
    required this.onboardingUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel Talk",
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: startWithOnboarding
          ? OnboardingScreen(useCase: onboardingUseCase)
          : const LoginScreen(),
    );
  }
}
