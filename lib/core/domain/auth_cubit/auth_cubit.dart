import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrate/core/data/repository/water_repository.dart';
import 'package:hydrate/core/domain/auth_cubit/auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final FirebaseAuth _firebaseAuth;
  final WaterRepository _repository;
  late StreamSubscription<User?> _authStateSubscription;

  AuthCubit(this._firebaseAuth, this._repository) : super(AuthCubitInitial()) {
    _authStateSubscription =
        _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(AuthCubitAuthorized(user: user));
      } else {
        emit(AuthCubitUnauthorized());
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthCubitLoading());

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      emit(AuthCubitAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthCubitUnauthorized(error: e.toString()));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(AuthCubitLoading());
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;
      if (uid != null) {
        await _repository.createInitialDailyAmount(uid);
      }
      emit(AuthCubitAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthCubitUnauthorized());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(AuthCubitUnauthorized());
  }

  @override
  Future<void> close() {
    _authStateSubscription
        .cancel(); // Cancel the subscription when the cubit is closed
    return super.close();
  }
}
