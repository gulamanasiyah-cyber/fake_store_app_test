import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
