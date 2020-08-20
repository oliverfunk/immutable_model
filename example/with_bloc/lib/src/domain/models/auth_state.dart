import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthError extends AuthState {
  const AuthError();
}

class AuthRegistered extends AuthState {
  const AuthRegistered();
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn();
}
