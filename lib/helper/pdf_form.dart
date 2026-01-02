import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> downloadAndOpenPdf({
  required String assetPath,
  required String fileName,
}) async {
  // Load PDF from assets
  final byteData = await rootBundle.load(assetPath);

  // Get app document directory
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');

  // Write file
  await file.writeAsBytes(
    byteData.buffer.asUint8List(),
    flush: true,
  );

  // Open PDF
  await OpenFilex.open(file.path);
}
