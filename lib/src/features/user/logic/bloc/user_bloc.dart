import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/src/core/network/dio_client.dart';
import 'package:test_flutter/src/features/user/logic/events/user_event.dart';
import 'package:test_flutter/src/features/user/logic/states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _service;
  List _allUsers = [];
  int _lastId = 0;

  UserBloc(this._service) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        _lastId = 0;
        final users = await _service.fetchUsers(since: _lastId);
        _allUsers = users;
        _lastId = users.isNotEmpty ? users.last.id : 0;
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError('Failed to load users'));
      }
    });

    on<LoadMoreUsers>((event, emit) async {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        try {
          final newUsers = await _service.fetchUsers(since: _lastId);
          if (newUsers.isEmpty) {
            emit(UserLoaded(currentState.users, hasReachedMax: true));
          } else {
            _lastId = newUsers.last.id;
            emit(UserLoaded(currentState.users + newUsers));
          }
        } catch (e) {
          emit(UserError('Failed to load more users'));
        }
      }
    });

    on<RefreshUsers>((event, emit) async {
      try {
        final users = await _service.fetchUsers(since: 0);
        _lastId = users.isNotEmpty ? users.last.id : 0;
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError('Refresh failed'));
      }
    });
  }
}
