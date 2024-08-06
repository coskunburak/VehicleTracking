import 'package:equatable/equatable.dart';

abstract class AddVehicleState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends AddVehicleState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AddVehicleState {
  @override
  List<Object> get props => [];
}

class UnAuthenticated extends AddVehicleState {
  final String error;

  UnAuthenticated({required this.error});

  @override
  List<Object> get props => [error];
}

class AddVehicleSuccess extends AddVehicleState {
  @override
  List<Object> get props => [];
}

class ResetPasswordFailure extends AddVehicleState {
  final String error;

  ResetPasswordFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class ResetPasswordSuccess extends AddVehicleState {
  @override
  List<Object> get props => [];
}