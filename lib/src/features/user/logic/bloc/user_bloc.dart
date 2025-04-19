import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/src/core/network/dio_client.dart';
import 'package:test_flutter/src/features/user/data/models/user_model.dart';
import 'package:test_flutter/src/features/user/logic/events/user_event.dart';
import 'package:test_flutter/src/features/user/logic/states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _service;
  int _currentPage = 1;

  UserBloc(this._service) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await _service.fetchUsers(page: 1);
        _currentPage = 1;

        emit(UserLoaded(
          users: users,
          hasReachedMax: users.length < 6, // Using default per_page value
          currentPage: _currentPage,
        ));
      } catch (e) {
        emit(UserError('Failed to load users: ${e.toString()}'));
      }
    });

    on<LoadMoreUsers>((event, emit) async {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        try {
          final newUsers = await _service.fetchUsers(page: _currentPage + 1);
          _currentPage++;

          emit(UserLoaded(
            users: [...currentState.users, ...newUsers],
            hasReachedMax: newUsers.length < 6, // Using default per_page value
            currentPage: _currentPage,
          ));
        } catch (e) {
          emit(UserError('Failed to load more users: ${e.toString()}'));
        }
      }
    });

    on<RefreshUsers>((event, emit) async {
      try {
        final users = await _service.fetchUsers(page: 1);
        _currentPage = 1;

        emit(UserLoaded(
          users: users,
          hasReachedMax: users.length < 6, // Using default per_page value
          currentPage: _currentPage,
        ));
      } catch (e) {
        emit(UserError('Refresh failed: ${e.toString()}'));
      }
    });
  }
}
