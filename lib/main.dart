//material design library
import 'package:flutter/material.dart';
//state management package
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'services/auth_service.dart';
import 'utils/theme.dart';

//entry point of dart app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Zahn Ecke',
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
