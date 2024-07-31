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
        return Center(child: CircularProgressIndicator());
      } else if (state is ListLoaded) {
        final vehicles = state.plates; // State'ten araç plakalarını al

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          shrinkWrap: true,
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final plate = vehicles[index];
            return InkWell(
              onTap: () async {
                // Araç detay sayfasına yönlendir
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
                    // Silme işlemini BLoC üzerinden yap
                    context.read<ListBloc>().add(DeleteVehicle(plate));
                    // Silme işlemi sonrası listeyi güncelle
                    onDelete(index);
                  }
                  return delete;
                },
                key: UniqueKey(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
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
                        Text(plate),
                        const SizedBox(height: 4),
                        // Eğer ek bilgi gerekiyorsa, buraya ekleyebilirsin
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
