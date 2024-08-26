import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiService _apiService;

  ProfileBloc(this._apiService) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LogoutEvent>(_onLogout); // Listen for LogoutEvent
    _loadProfileData();
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      final response = await _apiService.fetchProfileData(event.token);

      if (response.isEmpty) {
        emit(ProfileLoaded(
          name: 'N/A',
          email: 'N/A',
          studentId: 'N/A',
          hkType: 'N/A',
          status: 'N/A',
        ));
      } else {
        final user = UserModel.fromMap(response);

        emit(ProfileLoaded(
          name: '${user.firstName} ${user.lastName}',
          email: user.email,
          studentId: user.schoolID,
          hkType: user.role,
          status: user.status,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile data: $e'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      await _apiService.logout(event.context);
      emit(ProfileInitial());
    } catch (e) {
      emit(LogoutError(message: 'Failed to logout: $e'));
    }
  }

  Future<void> _loadProfileData() async {
    final token = await _getTokenFromSharedPreferences();
    if (token.isNotEmpty) {
      add(LoadProfileEvent(token: token));
    } else {
      emit(ProfileError(message: 'No authentication token found.'));
    }
  }

  Future<String> _getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }
}
