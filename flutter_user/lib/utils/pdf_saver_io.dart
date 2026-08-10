import 'dart:typed_data';
import 'package:printing/printing.dart';

/// Mobile/desktop: open the platform share/print sheet (Save to Files, etc.).
Future<void> savePdf(List<int> bytes, String filename) async {
  await Printing.sharePdf(bytes: Uint8List.fromList(bytes), filename: '$filename.pdf');
}
