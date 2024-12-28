import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthCubitState {}

class AuthCubitInitial extends AuthCubitState {}

class AuthCubitLoading extends AuthCubitState {}

class AuthCubitAuthorized extends AuthCubitState {
  final User user;

  AuthCubitAuthorized({required this.user});
}

class AuthCubitUnauthorized extends AuthCubitState {
  final String? error;

  AuthCubitUnauthorized({this.error});
}
