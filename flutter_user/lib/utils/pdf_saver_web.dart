import 'dart:async';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

bool _isIOS() {
  final ua = html.window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') ||
      ua.contains('ipad') ||
      ua.contains('ipod') ||
      // iPadOS 13+ reports as "Macintosh" but is touch-capable.
      (ua.contains('macintosh') && (html.window.navigator.maxTouchPoints ?? 0) > 1);
}

/// iOS Safari blocks opening a tab AFTER an async gap (the network fetch
/// consumes the user gesture). So on iOS we open a blank tab NOW, during the
/// tap, and navigate it to the PDF once the bytes arrive. Desktop/Android
/// download directly and need no pre-open.
Object? preparePdfTarget() => _isIOS() ? html.window.open('about:blank', '_blank') : null;

void closePdfTarget(Object? target) {
  if (target is html.WindowBase) {
    try {
      target.close();
    } catch (_) {}
  }
}

/// Web: deliver the PDF bytes to the browser.
/// - iOS: navigate the pre-opened tab to the PDF (Safari renders it → user can
///   Share → "Save to Files"); works in installed PWAs too.
/// - Desktop/Android: honour the `download` attribute → direct file download.
Future<void> savePdf(List<int> bytes, String filename, {Object? target}) async {
  final blob = html.Blob(<Object>[Uint8List.fromList(bytes)], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  if (target is html.WindowBase) {
    // Pre-opened iOS tab → point it at the freshly-built PDF.
    try {
      target.location.href = url;
    } catch (_) {
      html.window.open(url, '_blank');
    }
  } else if (_isIOS()) {
    html.window.open(url, '_blank');
  } else {
    final anchor = html.AnchorElement(href: url)
      ..download = '$filename.pdf'
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }

  // Release the blob URL only after the browser has had time to use it —
  // revoking immediately cancels the open/download on Safari.
  Timer(const Duration(seconds: 60), () => html.Url.revokeObjectUrl(url));
}
