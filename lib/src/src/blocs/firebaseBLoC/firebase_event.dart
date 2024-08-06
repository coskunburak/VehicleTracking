import 'package:equatable/equatable.dart';

abstract class FirebaseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserInfoRequested extends FirebaseEvent {
  final String uid;

  FetchUserInfoRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}

class UpdateUserInfoRequested extends FirebaseEvent {
  final String uid;
  final Map<String, dynamic> data;

  UpdateUserInfoRequested({required this.uid, required this.data});

  @override
  List<Object> get props => [uid, data];
}

class DeleteUserRequested extends FirebaseEvent {
  final String uid;

  DeleteUserRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}

class UpdatePasswordRequested extends FirebaseEvent {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordRequested({required this.oldPassword, required this.newPassword});

  @override
  List<Object> get props => [oldPassword, newPassword];
}


