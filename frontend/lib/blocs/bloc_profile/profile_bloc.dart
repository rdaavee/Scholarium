import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GlobalRepositoryImpl _globalService;
  final StudentRepositoryImpl _studentService;

  ProfileBloc(this._globalService, this._studentService)
      : super(ProfileInitial()) {
    on<ProfileInitialEvent>(profileInitialEvent);
    on<FetchProfileEvent>(fetchProfile);
    on<FetchUserDataEvent>(fetchUserData);
    on<LogoutEvent>(_onLogout);
    on<PickImageEvent>(uploadProfileImage);
  }

  Future<void> uploadProfileImage(
      PickImageEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await _globalService.uploadProfileImage(File(event.imagePath));
      await fetchProfile(FetchProfileEvent(), emit);
    } catch (error) {
      emit(ProfileErrorState(message: 'Failed to upload image: $error'));
    }
  }

  FutureOr<void> profileInitialEvent(
      ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    emit(
      ProfileLoadedSuccessState(users: const [], hours: []),
    );
  }

  Future<void> fetchProfile(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      UserModel user = await _globalService.fetchUserProfile();
      emit(ProfileLoadedSuccessState(users: [user], hours: []));
    } catch (e) {
      emit(ProfileErrorState(message: 'Failed to load profile data: $e'));
    }
  }

  FutureOr<void> fetchUserData(
      FetchUserDataEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      DtrHoursModel totalhours = await _studentService.fetchDtrTotalHoursData(event.schoolId);
      UserModel user = await _globalService.fetchUserData(event.schoolId);
      emit(ProfileLoadedSuccessState(users: [user], hours: [totalhours]));
    } catch (e) {
      emit(ProfileErrorState(message: 'Failed to load profile data: $e'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      await _globalService.logout(event.context);
    } catch (e) {
      emit(LogoutErrorState(message: 'Failed to logout: $e'));
    }
  }
}
