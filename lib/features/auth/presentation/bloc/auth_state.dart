import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final String username;

  const AuthSuccess({required this.token, required this.username});

  @override
  List<Object?> get props => [token, username];
}

abstract class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthValidationError extends AuthError {
  const AuthValidationError(super.message);
}

class AuthCredentialError extends AuthError {
  const AuthCredentialError(super.message);
}

class AuthServerError extends AuthError {
  const AuthServerError(super.message);
}
