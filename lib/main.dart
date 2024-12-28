import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrate/core/data/repository/water_repository.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit.dart';
import 'package:hydrate/core/router/app_router.dart';
import 'package:hydrate/core/util/notification_service.dart';
import 'package:hydrate/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  await notificationService.init();

  notificationService.startMinuteNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final drinkRepository = WaterRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(FirebaseAuth.instance, drinkRepository),
        ),
        BlocProvider(
          create: (context) =>
              WaterCubit(drinkRepository)..loadDrinksAndDailys(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
      ),
    );
  }
}
