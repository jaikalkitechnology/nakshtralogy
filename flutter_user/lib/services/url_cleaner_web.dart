// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Strip the `?token=&refresh=` (and any OAuth params) from the browser URL
/// after a successful callback so the session tokens don't linger in history.
void cleanAuthQueryFromUrl() {
  try {
    final loc = html.window.location;
    final clean = '${loc.origin}${loc.pathname}';
    html.window.history.replaceState(null, '', clean);
  } catch (_) {/* best-effort */}
}
