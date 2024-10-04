// ignore_for_file: avoid_print

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GlobalRepositoryImpl _apiService;

  AuthenticationBloc(this._apiService) : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<LoginAutomaticEvent>(automaticLogin);
  }

  Future<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<AuthenticationState> emit) async {
    emit(LoginLoadingState());
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }

  Future<void> storeToken(
      String token, String schoolID, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setString('token', token);
    print(token);
    await prefs.setString('schoolID', schoolID);
    await prefs.setString('password', password);
    await prefs.setString('login', "true");
    await prefs.setBool('onboard', true);
  }

  Future<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<AuthenticationState> emit) async {
    print("Login btn clicked!");
    emit(LoginLoadingState());
    try {
      final result = await _apiService.loginUser(
        schoolID: event.schoolID,
        password: event.password,
      );

      if (result['statusCode'] == 200) {
        final token = result['token'];
        final role = result['role'];
        final schoolID = event.schoolID;
        final password = event.password;
        storeToken(token, schoolID, password);
        print(schoolID + password);

        if (token != null && role != null) {
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
        final errorMessage = result['error'] ?? 'Unexpected error';
        print(errorMessage);
        emit(LoginErrorState(errorMessage: errorMessage));
      }
    } catch (e) {
      print('Unexpected error: $e');
      emit(LoginErrorState(errorMessage: 'Unexpected error: $e'));
    }
  }

  Future<void> automaticLogin(
      LoginAutomaticEvent event, Emitter<AuthenticationState> emit) async {
    try {
      final result = await _apiService.loginUser(
        schoolID: event.schoolID,
        password: event.password,
      );

      if (result['statusCode'] == 200) {
        final token = result['token'];
        final role = result['role'];
        final schoolID = event.schoolID;
        final password = event.password;
        storeToken(token, schoolID, password);
        print(schoolID + password);

        if (token != null && role != null) {
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
        final errorMessage = result['error'] ?? 'Unexpected error';
        print(errorMessage);
        emit(LoginErrorState(errorMessage: errorMessage));
      }
    } catch (e) {
      print('Unexpected error: $e');
      emit(LoginErrorState(errorMessage: 'Unexpected error: $e'));
    }
  }
}
