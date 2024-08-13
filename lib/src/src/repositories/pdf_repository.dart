import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

Future<void> generateVehiclePdf(Map<String, dynamic> vehicle, String imagePath) async {
  final pdf = pw.Document();

  // Firestore Storage'dan resmi indirin
  final imageUrl = await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
  final imageBytes = (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl)).buffer.asUint8List();

  // PDF'e eklemek için resmi hazırlayın
  final image = pw.MemoryImage(imageBytes);

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Arac Raporu',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),

                pw.Text('Arac Detaylari', style: pw.TextStyle(fontSize: 22)),
                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey, width: 1),
                  columnWidths: {
                    0: pw.FlexColumnWidth(3),
                    1: pw.FlexColumnWidth(4),
                  },
                  children: [
                    _buildTableRow('Plaka', vehicle['plate'].toString()),
                    _buildTableRow('Cihaz ID', vehicle['deviceId'].toString()),
                    _buildTableRow('Aktif', vehicle['isActive'] ? 'Evet' : 'Hayır'),
                    _buildTableRow('Sensor', vehicle['sensors'].toString()),
                    _buildTableRow('Hiz', '${vehicle['speed'].toString()} km/h'),
                    _buildTableRow('KM', '${vehicle['km'].toString()} km'),
                    _buildTableRow('Yakit Seviyesi', '${vehicle['fuelTankLevel'].toString()}%'),
                    _buildTableRow('Enlem', vehicle['latitude'].toString()),
                    _buildTableRow('Boylam', vehicle['longitude'].toString()),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),

                // Footer
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text(
                    'Rapor olusturulma tarihi: ${DateTime.now().toString().substring(0, 19)}',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                  ),
                ),
              ],
            ),

            // Resmi sağ üst köşeye ekleyin
            pw.Positioned(
              top: 0,
              right: 0,
              child: pw.Container(
                width: 100,
                height: 100,
                child: pw.Image(image),
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

pw.TableRow _buildTableRow(String attribute, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          attribute,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          value,
          style: pw.TextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}
