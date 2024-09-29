import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepositoryImpl _adminRepositoryImpl;
  AdminBloc(this._adminRepositoryImpl) : super(AdminInitialState()) {
    on<AdminInitialEvent>(adminInitialEvent);
    on<FetchDataEvent>(_onFetchDataEvent);
  }

  FutureOr<void> adminInitialEvent(
      AdminInitialEvent event, Emitter<AdminState> emit) async {
    emit(AdminInitialState());
    emit(AdminLoadingState());
    emit(AdminLoadedSuccessState(users: const [], activeCount: 0, inactiveCount: 0));
  }

  Future<void> _onFetchDataEvent(
      FetchDataEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoadingState()); // Emit loading state before fetching data
    try {
      final users = await _adminRepositoryImpl.fetchAllUsers();
      int activeCount = users.where((user) => user.status == 'Active').length;
      int inactiveCount =
          users.where((user) => user.status == 'Inactive').length;

      emit(AdminLoadedSuccessState(
          users: users,
          activeCount: activeCount,
          inactiveCount: inactiveCount));
    } catch (e) {
      emit(AdminErrorState(message: 'Failed to load data: $e'));
    }
  }
}
