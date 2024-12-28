import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit_state.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit_state.dart';
import 'package:hydrate/features/auth/auth_page.dart';
import 'package:hydrate/features/water/widgets/water_intake_circle.dart';

class WaterPage extends StatelessWidget {
  const WaterPage({super.key});

  static const String path = '/water';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitUnauthorized) {
          context.go(AuthPage.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Water Intake',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 102, 242, 252),
        ),
        body: BlocBuilder<WaterCubit, WaterCubitState>(
          builder: (context, state) {
            if (state is WaterCubitLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WaterCubitLoaded) {
              final dailyAmount = state.daylis.isNotEmpty
                  ? state.daylis.last.dailyAmount
                  : 2000;
              final amountTaken = state.drinks.isNotEmpty
                  ? state.drinks
                      .map((v) => v.amountTaken)
                      .reduce((a, b) => a + b)
                  : 0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WaterIntakeCircle(
                    amountTaken: amountTaken.toDouble(),
                    dailyAmount: dailyAmount.toDouble(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final waterCubit = context.read<WaterCubit>();
                      final uid = await waterCubit.getUid();
                      // ignore: use_build_context_synchronously
                      context.read<WaterCubit>().addDrink(250, now, uid!);
                    },
                    child: Text(
                      "Add 250 ml",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final drinkId = state.drinks.last.drinkId;
                      context.read<WaterCubit>().deleteDrink(drinkId);
                    },
                    child: Text(
                      "Remove 250 ml",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is WaterCubitError) {
              return Center(
                child: Text(
                  state.error,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
