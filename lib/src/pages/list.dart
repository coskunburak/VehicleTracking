import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/widgets/list_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_yapisi/src/blocs/listBLoC/list_bloc.dart';
import 'package:bloc_yapisi/src/blocs/listBLoC/list_event.dart';
import 'package:bloc_yapisi/src/blocs/listBLoC/list_state.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int limitData = 0;

  int checkLimit() {
    if (DateTime.now().minute.toInt() % 2 != 0) {
      limitData = 3;
    } else {
      limitData = 5;
    }
    print(limitData);
    return limitData;
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ListBloc>(
            create: (context) =>
                ListBloc()..add(GetListVehicles(limit: checkLimit())),
          ),
        ],
        child: Scaffold(
            appBar: appBar(title: 'Listelerim', context: context),
            body: BlocConsumer<ListBloc, ListState>(
                listener: (vehicleContext, vehicleState) {
                  if (vehicleState is ListSuccessState) {
                    print(vehicleState.listData.toString());
                  } else if (vehicleState is ListErrorState) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                        const AlertDialog(content: Text('HATA')));
                  } else if (vehicleState is DeleteSuccess) {
                    vehicleContext
                        .read<ListBloc>()
                        .add(GetListVehicles(limit: checkLimit()));
                  }
                },
                builder: (vehicleContext, vehicleState) => vehicleState
                is! ListSuccessState
                    ? pageLoading()
                    : listScrollList(
                    vehicleState: vehicleState,
                    limit: checkLimit(),
                    onDelete: (index) {
                      vehicleContext.read<ListBloc>().add(DeleteVehicle(
                          deviceId: vehicleState.listData[index].id));
                    })))
      );
}
