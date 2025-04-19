import 'package:dio/dio.dart';
import 'package:test_flutter/src/features/user/data/models/user_model.dart';

class UserService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://reqres.in/api';

  Future<List<UserModel>> fetchUsers({int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/users',
        queryParameters: {
          'page': page,
          'per_page': 6, // reqres.in default per_page value
        },
      );

      // reqres.in returns data in a nested "data" field
      final List<dynamic> userList = response.data['data'];
      return userList.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception('Bad response: ${error.response?.statusCode}');
      default:
        return Exception('Network error occurred');
    }
  }
}
