import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit.dart';
import 'package:hydrate/features/auth/auth_page.dart';
import 'package:hydrate/features/auth/reg_page.dart';
import 'package:hydrate/features/water/calendar_page.dart';
import 'package:hydrate/features/water/settings_page.dart';
import 'package:hydrate/features/water/water_page.dart';
import 'package:hydrate/features/water/widgets/get_landing_page.dart';

abstract class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: InitialPage.path,
    routes: [
      GoRoute(
        path: InitialPage.path,
        builder: (context, state) => const InitialPage(),
      ),
      GoRoute(
        path: AuthPage.path,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: RegPage.path,
        builder: (context, state) => const RegPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.water),
                  label: 'Water',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WaterPage.path,
                builder: (context, state) => const WaterPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CalendarPage.path,
                builder: (context, state) => const CalendarPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SettingsPage.path,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (state.uri.toString() == WaterPage.path ||
          state.uri.toString() == SettingsPage.path) {
        context.read<WaterCubit>().loadDrinksAndDailys();
      }

      return null;
    },
  );
}
