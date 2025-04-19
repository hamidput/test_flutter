import 'package:test_flutter/src/features/user/data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final bool hasReachedMax;
  UserLoaded(this.users, {this.hasReachedMax = false});
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
