import 'package:get_it/get_it.dart';
import 'package:test_flutter/src/core/network/dio_client.dart';
import 'package:test_flutter/src/features/user/logic/bloc/user_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => UserService());
  getIt.registerFactory(() => UserBloc(getIt()));
}
