import 'package:test_flutter/src/features/user/data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final bool hasReachedMax;
  final int currentPage;

  UserLoaded({
    required this.users,
    required this.hasReachedMax,
    required this.currentPage,
  });
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
