import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrate/features/auth/reg_page.dart';
import 'package:hydrate/features/water/water_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  static const String path = '/start';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Если пользователь авторизован, перенаправляем на главную страницу (WaterPage)
        if (snapshot.hasData) {
          return const WaterPage();
        }
        // Если пользователь не авторизован, показываем страницу авторизации (RegPage)
        return const RegPage();
      },
    );
  }
}
