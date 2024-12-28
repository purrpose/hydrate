import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit_state.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit.dart';
import 'package:hydrate/features/auth/reg_page.dart';
import 'package:hydrate/features/water/water_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  static const String path = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitAuthorized) {
          context.read<WaterCubit>().loadDrinksAndDailys();
          context.go(WaterPage.path);
        } else if (state is AuthCubitUnauthorized && state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Authentication',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 68, 243, 243),
          actions: [
            TextButton(
              onPressed: () {
                context.go(RegPage.path);
              },
              child: Text(
                'Register',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    label: Text(
                      'Email',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Password',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().signIn(
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: BlocBuilder<AuthCubit, AuthCubitState>(
                    builder: (context, state) {
                      if (state is AuthCubitLoading) {
                        return const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      return Text(
                        'Log in',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
