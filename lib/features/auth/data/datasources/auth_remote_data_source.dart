import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final token = response.data['token'].toString();
        return token;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Server returned error code: $statusCode',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
