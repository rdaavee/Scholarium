// ignore_for_file: avoid_print

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/socket/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GlobalRepositoryImpl _globalService;
  final socketService = SocketService();

  AuthenticationBloc(this._globalService) : super(LoginInitial()) {
    on<PasswordInitialEvent>(passwordInitialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<GetOTPEvent>(getOTPEvent);
    on<VerifyCode>(verifyCode);
    on<ResetPasswordEvent>(resetPasswordEvent);
  }

  FutureOr<void> passwordInitialEvent(
      PasswordInitialEvent event, Emitter<AuthenticationState> emit) async {
    emit(PasswordLoadingState());
    emit(PasswordLoadedSuccessState());
  }

  Future<void> storeToken(
      String token, String schoolID, String password, String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setString('token', token);
    await prefs.setString('schoolID', schoolID);
    await prefs.setString('password', password);
    await prefs.setString('login', "true");
    await prefs.setString('role', role);
    await prefs.setBool('onboard', true);
  }

  Future<void> clearPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('login');
    await prefs.remove('schoolId');
    await prefs.remove('password');
  }

  Future<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<AuthenticationState> emit) async {
    print("Login btn clicked!");
    emit(LoginLoadingState());

    try {
      final result = await _globalService.loginUser(
        schoolID: event.schoolID,
        password: event.password,
        role: '',
        status: '',
      );

      if (result['statusCode'] == 200) {
        final token = result['token'];
        final role = result['role'];
        final status = result['status'];
        final schoolID = event.schoolID;
        final password = event.password;

        print(status);
        storeToken(token, schoolID, password, role);
        print(schoolID + password);

        if (status != "Inactive") {
          if (token != null && role != null) {
            await socketService.connectChatSocket(event.schoolID);
            await socketService.connectNotificationSocket(event.schoolID);
            switch (role) {
              case 'Student':
                print("Login to student!");
                emit(LoginNavigateToStudentHomePageActionState());
                break;
              case 'Professor':
                print("Login to professor!");
                emit(LoginNavigateToProfessorHomePageActionState());
                break;
              case 'Admin':
                emit(LoginNavigateToAdminHomePageActionState());
                break;
              default:
                print("Login Error!");
                emit(LoginErrorState(errorMessage: 'Undefined role'));
            }
          } else {
            print('Token or role is null');
            emit(LoginErrorState(errorMessage: 'Invalid login response'));
          }
        } else {
          await clearPrefs();
          emit(LoginInactiveAccountState());
        }
      } else {
        final errorMessage = result['error'] ?? 'Unexpected error';
        print(errorMessage);
        await clearPrefs();
        emit(LoginErrorState(errorMessage: errorMessage));
      }
    } catch (e) {
      print('Unexpected error: $e');
      emit(LoginErrorState(errorMessage: 'Unexpected error: $e'));
    }
  }

  FutureOr<void> getOTPEvent(
      GetOTPEvent event, Emitter<AuthenticationState> emit) async {
    try {
      await _globalService.forgotPassword(email: event.email);
      emit(EmailNavigateToOTPPageActionState());
    } catch (e) {
      emit(PasswordErrorState(message: 'Failed to get OTP: $e'));
    }
  }

  FutureOr<void> verifyCode(
      VerifyCode event, Emitter<AuthenticationState> emit) async {
    try {
      await _globalService.verifyCode(email: event.email, code: event.code);
      emit(OTPNavigateToResetPageActionState());
    } catch (e) {
      emit(PasswordErrorState(message: 'Failed to update password: $e'));
    }
  }

  FutureOr<void> resetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthenticationState> emit) async {
    try {
      await _globalService.resetPassword(
          email: event.email, newPassword: event.newPassword);
      emit(ResetPasswordNavigateToLoginPageActionState());
    } catch (e) {
      emit(PasswordErrorState(message: 'Failed to update password: $e'));
    }
  }
}
