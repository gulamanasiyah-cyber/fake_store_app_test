import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login(String username, String password) async {
    try {
      return await remoteDataSource.login(username, password);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse ||
          (e.response != null &&
              (e.response!.statusCode == 400 ||
                  e.response!.statusCode == 401))) {
        throw const CredentialFailure('Incorrect username or password. Please try again.');
      } else {
        throw const ServerFailure('Connection failed. Please check your network or try again later.');
      }
    } on TypeError catch (e) {
      throw ServerFailure('Response parsing error: $e');
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: $e');
    }
  }
}
