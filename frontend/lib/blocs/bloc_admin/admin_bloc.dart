import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepositoryImpl _adminRepositoryImpl;

  AdminBloc(this._adminRepositoryImpl) : super(AdminInitialState()) {
    on<AdminInitialEvent>(adminInitialEvent);
    on<FetchDataEvent>(_onFetchDataEvent);
    on<FetchUsersEvent>(_onFetchUsersEvent);
    on<CreateUserEvent>(_onCreateUserEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);
    on<FetchAnnouncementsEvent>(_onFetchAnnouncementEvent);
    on<CreateAnnouncementEvent>(_onCreateAnnouncementEvent);
    on<UpdateAnnouncementEvent>(_onUpdateAnnouncementEvent);
    on<DeleteAnnouncementEvent>(_onDeleteAnnouncementEvent);
  }

  FutureOr<void> adminInitialEvent(
      AdminInitialEvent event, Emitter<AdminState> emit) async {
    emit(AdminInitialState());
    emit(AdminLoadingState());
    emit(AdminLoadedSuccessState(
        users: const [],
        announcements: const [],
        activeCount: 0,
        inactiveCount: 0,
        completedSchedulesCount: 0,
        todaySchedulesCount: 0));
  }

  Future<void> _onFetchDataEvent(
      FetchDataEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final users = await _adminRepositoryImpl.fetchAllUsers();
      int activeCount = users.where((user) => user.status == 'Active').length;
      int inactiveCount =
          users.where((user) => user.status == 'Inactive').length;

      final schedules = await _adminRepositoryImpl.fetchYearSchedule();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      int completedSchedulesCount = schedules
          .where((schedule) => schedule.isCompleted?.toLowerCase() == 'true')
          .length;
      print(completedSchedulesCount);
      int todaySchedulesCount = schedules
          .where((schedule) =>
              schedule.date == today &&
              schedule.isCompleted?.toLowerCase() != 'true')
          .length;
      print(todaySchedulesCount);

      emit(AdminLoadedSuccessState(
          users: users,
          announcements: const [],
          activeCount: activeCount,
          inactiveCount: inactiveCount,
          completedSchedulesCount: completedSchedulesCount,
          todaySchedulesCount: todaySchedulesCount));
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to load users: $e'));
    }
  }

//--------------------------------------USER FUNCTION----------------------------------------------------------------
  Future<void> _onFetchUsersEvent(
      FetchUsersEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());

    try {
      List<UserModel> allUsers = await _adminRepositoryImpl.fetchAllUsers();

      List<UserModel> filteredUsers = allUsers.where((user) {
        bool matchesRole = true;
        bool matchesStatus = true;

        if (event.selectedRole != 'All Users') {
          matchesRole = user.role == event.selectedRole;
        }

        if (event.statusFilter != 'Any') {
          matchesStatus = user.status == event.statusFilter;
        }

        return matchesRole && matchesStatus;
      }).toList();

      emit(AdminListScreenSuccessState(filteredUsers: filteredUsers));
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to fetch users: $e'));
    }
  }

  Future<void> _onCreateUserEvent(
      CreateUserEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.createUser(event.user);
      add(FetchDataEvent());
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to create user: $e'));
    }
  }

  Future<void> _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.updateUser(event.schoolId, event.user);
      add(FetchDataEvent());
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to update user: $e'));
    }
  }

  Future<void> _onDeleteUserEvent(
      DeleteUserEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.deleteUser(event.schoolId);
      add(FetchDataEvent());
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to delete user: $e'));
    }
  }

//-------------------------------ANNOUNCEMENT FUNCTION---------------------------------------------------------------
  FutureOr<void> _onFetchAnnouncementEvent(
      FetchAnnouncementsEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      List<AnnouncementModel> allAnnouncement =
          await _adminRepositoryImpl.fetchAllAnnouncements();
      emit(AdminLoadedSuccessState(
          users: const [],
          announcements: allAnnouncement,
          activeCount: 0,
          inactiveCount: 0,
          completedSchedulesCount: 0,
          todaySchedulesCount: 0));
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to load announcement: $e'));
    }
  }

  Future<void> _onCreateAnnouncementEvent(
      CreateAnnouncementEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token').toString();

      await _adminRepositoryImpl.createAnnouncement(token, event.announcement);
      add(FetchDataEvent());
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to create announcement: $e'));
    }
  }

  Future<void> _onUpdateAnnouncementEvent(
      UpdateAnnouncementEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token').toString();
      await _adminRepositoryImpl.updateAnnouncement(token, event.announcement);
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to update announcement: $e'));
    }
  }

  Future<void> _onDeleteAnnouncementEvent(
      DeleteAnnouncementEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.deleteAnnouncement(event.id);
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to delete announcement: $e'));
    }
  }
}
