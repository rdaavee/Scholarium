import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GlobalRepositoryImpl _apiService;

  ProfileBloc(this._apiService) : super(ProfileInitial()) {
    on<ProfileInitialEvent>(profileInitialEvent);
    on<FetchProfileEvent>(fetchProfile);
    on<LogoutEvent>(_onLogout); // Listen for LogoutEvent
  }

  FutureOr<void> profileInitialEvent(
      ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    emit(
      ProfileLoadedSuccessState(users: const []),
    );
  }

  Future<void> fetchProfile(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      UserModel user = await _apiService.fetchUserData();
      emit(ProfileLoadedSuccessState(users: [user]));
    } catch (e) {
      emit(ProfileErrorState(message: 'Failed to load profile data: $e'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      await _apiService.logout(event.context);
      emit(ProfileInitial());
    } catch (e) {
      emit(LogoutErrorState(message: 'Failed to logout: $e'));
    }
  }
}
