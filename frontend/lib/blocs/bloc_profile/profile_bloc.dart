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
    try {
      final response = await _apiService.fetchProfileData(event.token);

      if (response.isEmpty) {
        emit(ProfileLoadedSuccessState(
          name: 'N/A',
          email: 'N/A',
          studentId: 'N/A',
          gender: 'N/A',
          contact: 'N/A',
          address: 'N/A',
          hkType: 'N/A',
          status: 'N/A',
          profilePicture: '',
        ));
      } else {
        final user = UserModel.fromMap(response);

        emit(ProfileLoadedSuccessState(
          name: '${user.firstName} ${user.lastName}',
          email: user.email,
          studentId: user.schoolID,
          gender: user.gender,
          contact: user.contact,
          address: user.address,
          hkType: user.hkType,
          status: user.status,
          profilePicture: user.profilePicture,
        ));
      }
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

  Future<void> _loadProfileData() async {
    final token = await _getTokenFromSharedPreferences();
    if (token.isNotEmpty) {
      add(LoadProfileEvent(token: token));
    } else {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(ProfileErrorState(message: 'No authentication token found.'));
    }
  }

  Future<String> _getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
