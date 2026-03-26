import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  static const String _keyCompleted = "onboarding_completed";

  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_keyCompleted) ?? false);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, true);
  }
}
