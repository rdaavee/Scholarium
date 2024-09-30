import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepositoryImpl _adminRepositoryImpl;

  AdminBloc(this._adminRepositoryImpl) : super(AdminInitialState()) {
    on<AdminInitialEvent>(adminInitialEvent);
    on<FetchDataEvent>(_onFetchDataEvent);
    on<CreateUserEvent>(_onCreateUserEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);
    on<CreateAnnouncementEvent>(_onCreateAnnouncementEvent);
    on<UpdateAnnouncementEvent>(_onUpdateAnnouncementEvent);
    on<DeleteAnnouncementEvent>(_onDeleteAnnouncementEvent);
  }

  FutureOr<void> adminInitialEvent(
      AdminInitialEvent event, Emitter<AdminState> emit) async {
    emit(AdminInitialState());
    emit(AdminLoadingState());
    emit(AdminLoadedSuccessState(users: const [], activeCount: 0, inactiveCount: 0));
  }

  Future<void> _onFetchDataEvent(
      FetchDataEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final users = await _adminRepositoryImpl.fetchAllUsers();
      int activeCount = users.where((user) => user.status == 'Active').length;
      int inactiveCount = users.where((user) => user.status == 'Inactive').length;

      emit(AdminLoadedSuccessState(users: users, activeCount: activeCount, inactiveCount: inactiveCount));
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to load users: $e'));
    }
  }

  Future<void> _onCreateUserEvent(CreateUserEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.createUser(event.user);
      add(FetchDataEvent());
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to create user: $e'));
    }
  }

  Future<void> _onUpdateUserEvent(UpdateUserEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.updateUser(event.schoolId, event.user);
      add(FetchDataEvent());
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to update user: $e'));
    }
  }

  Future<void> _onDeleteUserEvent(DeleteUserEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.deleteUser(event.schoolId);
      add(FetchDataEvent()); 
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to delete user: $e'));
    }
  }

  Future<void> _onCreateAnnouncementEvent(CreateAnnouncementEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.createAnnouncement(event.announcement);
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to create announcement: $e'));
    }
  }

  Future<void> _onUpdateAnnouncementEvent(UpdateAnnouncementEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.updateAnnouncement(event.id, event.announcement);
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to update announcement: $e'));
    }
  }

  Future<void> _onDeleteAnnouncementEvent(DeleteAnnouncementEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      await _adminRepositoryImpl.deleteAnnouncement(event.id);
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to delete announcement: $e'));
    }
  }
}
