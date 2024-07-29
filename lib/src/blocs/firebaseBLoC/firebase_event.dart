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

class UpdateUserRequested extends FirebaseEvent {
  final String uid;
  final String email;

  UpdateUserRequested({required this.uid, required this.email});

  @override
  List<Object> get props => [uid, email];
}

class DeleteUserRequested extends FirebaseEvent {
  final String uid;

  DeleteUserRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}
