import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/listBLoC/list_bloc.dart';
import '../blocs/listBLoC/list_event.dart';
import '../blocs/listBLoC/list_state.dart';
import '../repositories/vehicle_repository.dart';
import 'package:bloc_yapisi/src/elements/addButton.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/pages/vehicleDetail.dart';

import '../widgets/list_body.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Liste"),
      body: BlocProvider(
        create: (context) => ListBloc(VehicleRepository())..add(FetchVehicles()),
        child: listScrollList(
          onDelete: (plate) {
            context.read<ListBloc>().add(FetchVehicles()); // Listeyi güncelleer
          },
        ),
      ),
      floatingActionButton: addButton(context: context),
    );
  }
}

