import '../data/onboarding_repository.dart';

class OnboardingUseCase {
  final OnboardingRepository repository;

  OnboardingUseCase({required this.repository});

  Future<bool> isFirstTime() {
    return repository.isFirstTime();
  }

  Future<void> completeOnboarding() {
    return repository.completeOnboarding();
  }
}
