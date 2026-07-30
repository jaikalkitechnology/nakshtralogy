#!/usr/bin/env python3
"""
Merge new l10n keys from agents into flutter_user ARBs + regenerate delegates.

Input JSON: a list of {key, en, hi?, hinglish?, placeholders?: [names]}.
- Inserts each key into all 11 ARB files (en/hi/hi_Latn get real values;
  other 8 locales get the English value as interim, tracked as pending).
- app_en.arb also gets @key placeholder metadata for placeholder keys.
- Regenerates gen/ abstract + concrete getters (or methods for placeholder keys),
  matching `flutter gen-l10n` output so a future real regen is a no-op diff.

Usage: python3 merge_l10n.py newkeys.json [--dry]
"""
import json, sys, glob, os, html

APP = "flutter_user"
for i, a in enumerate(sys.argv):
    if a == "--app":
        APP = sys.argv[i + 1]
L10N = f"/home/user/nakshtralogy/{APP}/lib/l10n"
GEN = os.path.join(L10N, "gen")
ARB = {  # locale -> arb filename
    "en": "app_en.arb", "hi": "app_hi.arb", "hi_Latn": "app_hi_Latn.arb",
    "bn": "app_bn.arb", "ta": "app_ta.arb", "te": "app_te.arb", "kn": "app_kn.arb",
    "ml": "app_ml.arb", "gu": "app_gu.arb", "mr": "app_mr.arb", "pa": "app_pa.arb",
}
# ARB anchor: insert after the @@locale line.  GEN anchor: after forgotPassword.
DRY = "--dry" in sys.argv
# positional infile = first non-flag arg that isn't the value following --app
_skip = set()
for i, a in enumerate(sys.argv):
    if a == "--app":
        _skip.add(i + 1)
infile = [a for i, a in enumerate(sys.argv[1:], 1)
          if not a.startswith("-") and i not in _skip][0]

raw = json.load(open(infile, encoding="utf-8"))


def norm_placeholders(item):
    """Return list of (name, dart_type) or [] . Accepts list or dict forms."""
    ph = item.get("placeholders")
    if not ph:
        return []
    if isinstance(ph, dict):
        out = []
        for name, spec in ph.items():
            if isinstance(spec, dict):
                out.append((name, spec.get("type", "Object")))
            elif isinstance(spec, str):
                out.append((name, spec))          # {"sign": "String"}
            else:
                out.append((name, "Object"))
        return out
    return [(name, "Object") for name in ph]       # ["a","b"]


# dedupe by key (first wins); warn on conflicting en
seen = {}
for item in raw:
    k = item["key"]
    if k in seen:
        if seen[k]["en"] != item.get("en"):
            print(f"WARN dup key '{k}' with differing en: {seen[k]['en']!r} vs {item.get('en')!r} (keeping first)")
        continue
    seen[k] = item
newkeys = list(seen.values())
# normalize any HTML-entity-escaped values (&amp; -> &, etc.)
for item in newkeys:
    for f in ("en", "hi", "hinglish"):
        if isinstance(item.get(f), str):
            item[f] = html.unescape(item[f])
print(f"{len(newkeys)} unique new keys")

# skip keys already in app_en.arb
en_existing = json.load(open(os.path.join(L10N, ARB["en"]), encoding="utf-8"))
newkeys = [k for k in newkeys if k["key"] not in en_existing]
print(f"{len(newkeys)} after removing already-existing keys")
if not newkeys:
    print("nothing to do"); sys.exit(0)


def val_for(item, loc):
    if loc == "en": return item["en"]
    if loc == "hi": return item.get("hi") or item["en"]
    if loc == "hi_Latn": return item.get("hinglish") or item["en"]
    return item["en"]  # 8 other locales: english interim (pending backfill)


def dart_str(s):
    return s.replace("\\", "\\\\").replace("\n", "\\n").replace("'", "\\'")


def dart_body(s, names):
    s = dart_str(s)
    for p in names:
        s = s.replace("{" + p + "}", "${" + p + "}")
    return s


# ── 1. ARB files ──
for loc, fn in ARB.items():
    path = os.path.join(L10N, fn)
    data_existing = json.load(open(path, encoding="utf-8"))
    lines = open(path, encoding="utf-8").readlines()
    idx = next(i for i, l in enumerate(lines) if '"@@locale"' in l)
    block = []
    for item in newkeys:
        k = item["key"]
        if k in data_existing:  # already present in this locale
            continue
        v = val_for(item, loc)
        block.append(f"  {json.dumps(k)}: {json.dumps(v, ensure_ascii=False)},\n")
        phs = norm_placeholders(item)
        if loc == "en" and phs:
            meta = {"placeholders": {name: {"type": typ} for name, typ in phs}}
            block.append(f"  {json.dumps('@'+k)}: {json.dumps(meta, ensure_ascii=False)},\n")
    if block:
        lines[idx+1:idx+1] = block
        if DRY:
            print(f"[dry] {fn}: +{len(block)} lines")
        else:
            open(path, "w", encoding="utf-8").writelines(lines)
    # validate JSON after write
    if not DRY:
        json.load(open(path, encoding="utf-8"))

# ── 2. gen abstract ──
abs_path = os.path.join(GEN, "app_localizations.dart")
lines = open(abs_path, encoding="utf-8").readlines()
anchor = next(i for i, l in enumerate(lines) if l.strip() == "String get forgotPassword;")
decl = []
for item in newkeys:
    k = item["key"]; phs = norm_placeholders(item)
    decl.append("\n")
    decl.append(f"  /// No description provided for @{k}.\n  ///\n")
    decl.append(f"  /// In en, this message translates to:\n")
    decl.append(f"  /// **'{dart_str(item['en'])}'**\n")
    if phs:
        args = ", ".join(f"{typ} {name}" for name, typ in phs)
        decl.append(f"  String {k}({args});\n")
    else:
        decl.append(f"  String get {k};\n")
if not DRY:
    lines[anchor+1:anchor+1] = decl
    open(abs_path, "w", encoding="utf-8").writelines(lines)
print(f"abstract: +{len(newkeys)} declarations")

# ── 3. gen concrete ──
for loc, fn in ARB.items():
    gen_fn = os.path.join(GEN, f"app_localizations_{loc}.dart")
    lines = open(gen_fn, encoding="utf-8").readlines()
    a = next(i for i, l in enumerate(lines) if l.strip().startswith("String get forgotPassword =>"))
    block = []
    for item in newkeys:
        k = item["key"]; phs = norm_placeholders(item)
        v = val_for(item, loc)
        block.append("\n  @override\n")
        if phs:
            args = ", ".join(f"{typ} {name}" for name, typ in phs)
            names = [name for name, _ in phs]
            block.append(f"  String {k}({args}) {{\n    return '{dart_body(v, names)}';\n  }}\n")
        else:
            block.append(f"  String get {k} => '{dart_str(v)}';\n")
    if not DRY:
        lines[a+1:a+1] = block
        open(gen_fn, "w", encoding="utf-8").writelines(lines)
print(f"concrete: +{len(newkeys)} overrides x 11 locales")
print("DONE" + (" (dry run)" if DRY else ""))
