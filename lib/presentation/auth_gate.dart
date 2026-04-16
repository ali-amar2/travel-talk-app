// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
// import 'package:travel_talk/features/home/presentation/screens/home_screen.dart';

// import '../data/onboarding_repository.dart';
// import '../domain/onboarding_usecase.dart';
// import 'login_screen.dart';
// import 'onboarding_screen.dart';

// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   final UserRepository _userRepository = UserRepository();

//   Future<Widget> _getStartScreen() async {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return const LoginScreen();
//     }

//     final userData = await _userRepository.getUserById(currentUser.uid);
//     final bool onboardingCompleted =
//         (userData?['onboardingCompleted'] as bool?) ?? false;

//     if (onboardingCompleted) {
//       return const HomeScreen();
//     }

//     return OnboardingScreen(
//       useCase: OnboardingUseCase(repository: OnboardingRepository()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Widget>(
//       future: _getStartScreen(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snapshot.hasError) {
//           return const Scaffold(
//             body: Center(child: Text('Something went wrong')),
//           );
//         }

//         return snapshot.data ?? const LoginScreen();
//       },
//     );
//   }
// }
