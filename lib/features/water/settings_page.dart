import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit_state.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit_state.dart';
import 'package:hydrate/features/auth/auth_page.dart';
import 'package:hydrate/features/water/water_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String path = '/settings';

  @override
  Widget build(BuildContext context) {
    final TextEditingController dailyAmountController = TextEditingController();

    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitUnauthorized) {
          context.read<WaterCubit>().reset();
          context.go(AuthPage.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 102, 242, 252),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Water Intake Goal',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dailyAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter daily amount (ml)',
                  labelStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<WaterCubit, WaterCubitState>(
                builder: (context, state) {
                  if (state is WaterCubitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WaterCubitLoaded) {
                    final id = state.daylis.last.id;
                    final idToDelete = state.daylis.first.id;
                    return ElevatedButton(
                      onPressed: () async {
                        final dailyAmount =
                            int.tryParse(dailyAmountController.text);
                        if (dailyAmount != null) {
                          context
                              .read<WaterCubit>()
                              .updateDailyAmount(dailyAmount, id);
                          context
                              .read<WaterCubit>()
                              .deleteDailyAmount(idToDelete);
                          context.go(WaterPage.path);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Daily amount updated',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Invalid input',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    context.read<AuthCubit>().signOut();
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
