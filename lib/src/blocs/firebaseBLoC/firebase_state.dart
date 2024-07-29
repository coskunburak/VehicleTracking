import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class FirebaseState extends Equatable {
  const FirebaseState();
}

class FirebaseInitial extends FirebaseState {
  @override
  List<Object> get props => [];
}

class UserInfoLoaded extends FirebaseState {
  final DocumentSnapshot userInfo;

  UserInfoLoaded({required this.userInfo});

  @override
  List<Object> get props => [userInfo];

  get error => null;
}

class FirebaseLoading extends FirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseError extends FirebaseState {
  final String error;

  FirebaseError({required this.error});

  @override
  List<Object> get props => [error];
}

class UserUpdated extends FirebaseState {
  @override
  List<Object> get props => [];
}

class UserDeleted extends FirebaseState {
  @override
  List<Object> get props => [];
}
