import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/listBLoC/list_bloc.dart';
import '../blocs/listBLoC/list_event.dart';
import '../blocs/listBLoC/list_state.dart';
import '../pages/vehicleDetail.dart';

Widget listScrollList({required Function(int) onDelete}) {
  return BlocBuilder<ListBloc, ListState>(
    builder: (context, state) {
      if (state is ListLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ListLoaded) {
        final vehicles = state.plates;
        final vehicleDetails = state.vehicleDetails;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          shrinkWrap: true,
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final plate = vehicles[index];
            final details = vehicleDetails[index];
            final sensors = details['sensors'] ?? 0;
            final speed = details['speed'] ?? 0.0;

            return InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailScreen(plate: plate),
                  ),
                );
              },
              child: Dismissible(
                confirmDismiss: (DismissDirection direction) async {
                  bool delete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Silme"),
                        content: const Text("Silinsin mi?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Hayır"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Evet"),
                          ),
                        ],
                      );
                    },
                  );
                  if (delete) {
                    context.read<ListBloc>().add(DeleteVehicle(plate));
                    onDelete(index);
                  }
                  return delete;
                },
                key: UniqueKey(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF0c3143),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(plate,style: const TextStyle(color: Colors.white),),
                            Row(
                              children: [
                                if (sensors > 50)
                                  const Tooltip(
                                    message: 'Yüksek Sıcaklık!',
                                    child: Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                if (speed > 120)
                                  const Tooltip(
                                    message: "Hız 120'den Fazla!",
                                    child: Icon(
                                      Icons.speed,
                                      color: Colors.amber,
                                    ),
                                  ),
                              ],
                            ),
                          ],

                        ),
                        const SizedBox(height: 4),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else if (state is ListError) {
        return Center(child: Text(state.message));
      } else {
        return Center(child: Text('No data'));
      }
    },
  );
}
