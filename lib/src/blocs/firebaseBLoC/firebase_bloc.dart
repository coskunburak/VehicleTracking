import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_event.dart';
import 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  final UserRepository userRepository;

  FirebaseBloc(FirebaseInitial firebaseInitial, {required this.userRepository})
      : super(FirebaseInitial()) {
    on<FetchUserInfoRequested>((event, emit) async {
      try {
        emit(FirebaseLoading());
        DocumentSnapshot userInfo = await userRepository.getUserInfo(event.uid);
        emit(UserInfoLoaded(userInfo: userInfo));
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
      }
    });

    on<UpdateUserInfoRequested>((event, emit) async {
      try {
        emit(FirebaseLoading());
        await userRepository.updateUserInfo(event.uid, event.data);
        await userRepository.updateEmail(event.data['email']);
        DocumentSnapshot userInfo = await userRepository.getUserInfo(event.uid);
        emit(UserInfoUpdated());
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
      }
    });

    on<DeleteUserRequested>((event, emit) async {
      try {
        emit(FirebaseLoading());
        await userRepository.deleteUser(event.uid);
        emit(UserDeleted());
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
      }
    });

    on<UpdatePasswordRequested>((event, emit) async {
      try {
        emit(FirebaseLoading());
        await userRepository.updatePassword(
            event.oldPassword, event.newPassword);
        emit(UserPasswordUpdated());
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
      }
    });
  }
}
