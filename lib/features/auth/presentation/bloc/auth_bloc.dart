import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<AuthLoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    if (event.username.trim().isEmpty) {
      emit(const AuthValidationError('Please enter your username'));
      return;
    }

    if (event.password.length < 6) {
      emit(const AuthValidationError('Password must be at least 6 characters long'));
      return;
    }

    emit(AuthLoading());

    try {
      final token = await loginUseCase(event.username.trim(), event.password);
      emit(AuthSuccess(token: token, username: event.username));
    } on CredentialFailure catch (e) {
      emit(AuthCredentialError(e.message));
    } on ServerFailure catch (e) {
      emit(AuthServerError(e.message));
    } catch (e) {
      emit(AuthServerError(e.toString()));
    }
  }
}
