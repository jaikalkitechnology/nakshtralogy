import 'package:flutter/material.dart';

/// Renders the light markdown the AI writes (**bold**, ### headings,
/// "- " / "• " bullets, "1. " lists) as styled text instead of showing the
/// raw symbols. One SelectableText, so a whole reply can still be selected
/// and copied.
class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown(this.text, {super.key, required this.style, required this.accent});

  final String text;
  final TextStyle style;
  final Color accent;

  static final _heading = RegExp(r'^\s{0,3}#{1,6}\s+(.*)$');
  static final _bullet = RegExp(r'^\s*[-*•]\s+(.*)$');
  static final _numbered = RegExp(r'^\s*(\d{1,2})[.)]\s+(.*)$');
  static final _bold = RegExp(r'\*\*(.+?)\*\*');

  List<InlineSpan> _inline(String line, TextStyle base) {
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in _bold.allMatches(line)) {
      if (m.start > last) spans.add(TextSpan(text: line.substring(last, m.start), style: base));
      spans.add(TextSpan(text: m.group(1), style: base.copyWith(fontWeight: FontWeight.w700, color: Colors.white)));
      last = m.end;
    }
    if (last < line.length) spans.add(TextSpan(text: line.substring(last), style: base));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final lines = text.replaceAll('\r', '').split('\n');
    final spans = <InlineSpan>[];
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final h = _heading.firstMatch(line);
      final b = _bullet.firstMatch(line);
      final n = _numbered.firstMatch(line);
      if (h != null) {
        spans.addAll(_inline(h.group(1)!, style.copyWith(
            fontWeight: FontWeight.w700, color: accent, fontSize: (style.fontSize ?? 13) + 1)));
      } else if (b != null) {
        spans.add(TextSpan(text: '  •  ', style: style.copyWith(color: accent, fontWeight: FontWeight.w700)));
        spans.addAll(_inline(b.group(1)!, style));
      } else if (n != null) {
        spans.add(TextSpan(text: '  ${n.group(1)}.  ', style: style.copyWith(color: accent, fontWeight: FontWeight.w700)));
        spans.addAll(_inline(n.group(2)!, style));
      } else {
        spans.addAll(_inline(line, style));
      }
      if (i < lines.length - 1) spans.add(TextSpan(text: '\n', style: style));
    }
    return SelectableText.rich(TextSpan(children: spans), style: style);
  }
}
