import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<LoginButtonNavigateEvent>(loginButtonNavigateEvent);
  }

  Future<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    await Future.delayed(
      Duration(seconds: 3),
    );
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginState> emit) {
    print("Login btn clicked!");
    // Add any logic before navigation here
    emit(LoginNavigateToStudentHomePageActionState());
  }

  FutureOr<void> loginButtonNavigateEvent(
      LoginButtonNavigateEvent event, Emitter<LoginState> emit) {
    emit(LoginNavigateToStudentHomePageActionState());
  }
}
