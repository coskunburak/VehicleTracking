import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';

abstract class ListState extends Equatable {
  const ListState();
}

class ListLoadingState extends ListState {
  @override
  List<dynamic> get props => [];
}

class ListSuccessState extends ListState {
  const ListSuccessState({required this.listData});

  final List<Vehicle> listData;

  @override
  List<dynamic> get props => [];
}

class ListErrorState extends ListState {
  @override
  List<dynamic> get props => [];
}

class DelErrorState extends ListState {
  @override
  List<dynamic> get props => [];
}

class DeleteLoading extends ListState {
  @override
  List<dynamic> get props => [];
}

class DeleteSuccess extends ListState {
  const DeleteSuccess({required this.listData});

  final List<Vehicle> listData;

  @override
  List<dynamic> get props => [];
}
