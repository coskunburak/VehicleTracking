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

  const UserInfoLoaded({required this.userInfo});

  @override
  List<Object> get props => [userInfo];
}

class FirebaseLoading extends FirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseError extends FirebaseState {
  final String error;

  const FirebaseError({required this.error});

  @override
  List<Object> get props => [error];
}

class UserDeleted extends FirebaseState {
  @override
  List<Object> get props => [];
}

class UserInfoUpdated extends FirebaseState {
  @override
  List<Object> get props => [];
}

class UserPasswordUpdated extends FirebaseState {
  @override
  List<Object> get props => [];
}
