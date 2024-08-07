import 'package:equatable/equatable.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded extends ListState {
  final List<String> plates;
  final List<Map<String, dynamic>> vehicleDetails;

  const ListLoaded(this.plates, this.vehicleDetails);

  @override
  List<Object> get props => [plates, vehicleDetails];
}

class ListError extends ListState {
  final String message;

  const ListError(this.message);

  @override
  List<Object> get props => [message];
}
