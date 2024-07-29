import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_event.dart';
import 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  final UserRepository userRepository;


  FirebaseBloc({required this.userRepository}) : super(FirebaseInitial()) {

    on<FetchUserInfoRequested>((event, emit) async {
      emit(FirebaseLoading());
      try {
        DocumentSnapshot userInfo = await userRepository.getUserInfo(event.uid);
        emit(UserInfoLoaded(userInfo: userInfo));
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
      }
    });



    on<UpdateUserRequested>((event, emit) async {
      emit(FirebaseLoading());
      try {
        await userRepository.updateUser(event.uid, event.email);
        emit(UserUpdated());
        print('Update request processed');
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
        print('Error during update request: ${e.toString()}');
      }
    });


    on<DeleteUserRequested>((event, emit) async {
      emit(FirebaseLoading());
      try {
        await userRepository.deleteUser(event.uid);
        emit(UserDeleted());
        print('Delete request processed');
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
        print('Error during delete request: ${e.toString()}');
      }
    });

  }
}
