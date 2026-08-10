import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web: trigger a real browser download of the PDF bytes (works even when the
/// printing plugin's preview path is unavailable / popups are blocked).
Future<void> savePdf(List<int> bytes, String filename) async {
  final blob = html.Blob(<Object>[Uint8List.fromList(bytes)], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = '$filename.pdf'
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}
