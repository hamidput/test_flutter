import 'package:dio/dio.dart';
import 'package:test_flutter/src/features/user/data/models/user_model.dart';

class UserService {
  final Dio _dio = Dio();

  Future<List<UserModel>> fetchUsers({int since = 0}) async {
    final response =
        await _dio.get('https://api.github.com/users?since=$since&per_page=10');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }
}
