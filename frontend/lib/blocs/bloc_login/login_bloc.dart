import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService _apiService;

  LoginBloc(this._apiService) : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
  }

  Future<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }

  Future<void> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    getToken();
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  Future<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginState> emit) async {
    print("Login btn clicked!");

    try {
      emit(LoginLoadingState());

      final result =
          await _apiService.loginUser(event.schoolID, event.password);

      if (result['statusCode'] == 200) {
        final token = result['token'];
        final role = result['role'];
        storeToken(token);

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
