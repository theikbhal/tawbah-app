import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/design_system.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  await NotificationService().init();
  
  final userProvider = UserProvider();
  await userProvider.loadUsers();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: const ZikirApp(),
    ),
  );
}

class ZikirApp extends StatelessWidget {
  const ZikirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawbah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    if (userProvider.currentUser == null) {
      return const OnboardingScreen();
    } else {
      return const DashboardScreen();
    }
  }
}
