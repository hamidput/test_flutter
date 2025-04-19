import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio dio;
  UserRepository(this.dio);

  Future<List<UserModel>> fetchUsers({int? since}) async {
    final response = await dio.get(
      'https://api.github.com/users',
      queryParameters: {'since': since ?? 0, 'per_page': 20},
    );

    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
