import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class UnAuthenticated extends AuthState {
  final String error;

  UnAuthenticated({required this.error});

  @override
  List<Object> get props => [error];
}

class SignUpSuccess extends AuthState {
  @override
  List<Object> get props => [];
}
