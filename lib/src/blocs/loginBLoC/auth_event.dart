import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String surname;

  SignUpRequested({required this.email, required this.password,required this.name,required this.surname});

  @override
  List<Object> get props => [email, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  ResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}


class FetchUserPermissions extends AuthEvent {
  final String uid;

  FetchUserPermissions(this.uid);
}


