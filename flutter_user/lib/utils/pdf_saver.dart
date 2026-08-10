// Cross-platform "save/share a PDF byte buffer".
// Web uses a native browser download (Blob + anchor) so the file reliably
// downloads; mobile/desktop use the printing share sheet.
export 'pdf_saver_io.dart' if (dart.library.html) 'pdf_saver_web.dart';
