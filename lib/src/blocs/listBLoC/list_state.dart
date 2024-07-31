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

  const ListLoaded(this.plates);

  @override
  List<Object> get props => [plates];
}

class ListError extends ListState {
  final String message;

  const ListError(this.message);

  @override
  List<Object> get props => [message];
}
