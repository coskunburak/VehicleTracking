import 'package:bloc_yapisi/src/pages/vehicleDetail.dart';
import '../blocs/listBLoC/list_state.dart';
import 'package:flutter/material.dart';

Widget listScrollList(
        {required ListSuccessState vehicleState,
        required int limit,
        required Function onDelete}) =>
    ListView.builder(
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        shrinkWrap: true,
        itemCount: vehicleState.listData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async => await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VehicleDetailScreen(
                        deviceId: vehicleState.listData[index].id))),
            child: Dismissible(
              confirmDismiss: (DismissDirection direction) async {
                bool delete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("silme"),
                      content: const Text("silinsin mi?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("hayır"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("evet"),
                        ),
                      ],
                    );
                  },
                );
                if (delete) {
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
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(vehicleState.listData[index].plate),
                      const SizedBox(height: 4),
                      Text(vehicleState.listData[index].id.toString()),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
