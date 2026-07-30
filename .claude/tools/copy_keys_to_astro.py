#!/usr/bin/env python3
"""
Copy a set of l10n keys (with whatever per-locale translations already exist)
from flutter_user ARBs into flutter_astro ARBs, and regenerate the astro gen
delegates to match `flutter gen-l10n`.

Values + @placeholder metadata are sourced from flutter_user (source of truth).
Keys already present in flutter_astro are skipped.

Usage: python3 copy_keys_to_astro.py keys.txt   (one key per line)
"""
import json, sys, os

SRC = "/home/user/nakshtralogy/flutter_user/lib/l10n"
DST = "/home/user/nakshtralogy/flutter_astro/lib/l10n"
ARB = {
    "en": "app_en.arb", "hi": "app_hi.arb", "hi_Latn": "app_hi_Latn.arb",
    "bn": "app_bn.arb", "ta": "app_ta.arb", "te": "app_te.arb", "kn": "app_kn.arb",
    "ml": "app_ml.arb", "gu": "app_gu.arb", "mr": "app_mr.arb", "pa": "app_pa.arb",
}

keys = [l.strip() for l in open(sys.argv[1]) if l.strip() and not l.startswith("#")]

src_en = json.load(open(os.path.join(SRC, ARB["en"]), encoding="utf-8"))
dst_en_orig = json.load(open(os.path.join(DST, ARB["en"]), encoding="utf-8"))

# keys actually needing add (not already in astro en)
added = [k for k in keys if k not in dst_en_orig]
missing_in_src = [k for k in keys if k not in src_en]
if missing_in_src:
    print("WARN not in flutter_user en (skipped):", missing_in_src)
added = [k for k in added if k in src_en]
print(f"{len(added)} keys to add to astro:", added)


def placeholders_of(k):
    meta = src_en.get("@" + k)
    if not meta or "placeholders" not in meta:
        return []
    return [(n, spec.get("type", "Object")) for n, spec in meta["placeholders"].items()]


def dart_str(s):
    return s.replace("\\", "\\\\").replace("\n", "\\n").replace("'", "\\'")


def dart_body(s, names):
    s = dart_str(s)
    for p in names:
        s = s.replace("{" + p + "}", "${" + p + "}")
    return s


# ── 1. ARB files ──
for loc, fn in ARB.items():
    src = json.load(open(os.path.join(SRC, fn), encoding="utf-8"))
    path = os.path.join(DST, fn)
    dst = json.load(open(path, encoding="utf-8"))
    lines = open(path, encoding="utf-8").readlines()
    idx = next(i for i, l in enumerate(lines) if '"@@locale"' in l)
    block = []
    for k in added:
        if k in dst:
            continue
        v = src.get(k, src_en[k])  # fall back to en if a locale lacks it
        block.append(f"  {json.dumps(k)}: {json.dumps(v, ensure_ascii=False)},\n")
        if loc == "en" and ("@" + k) in src_en:
            block.append(f"  {json.dumps('@'+k)}: {json.dumps(src_en['@'+k], ensure_ascii=False)},\n")
    if block:
        lines[idx+1:idx+1] = block
        open(path, "w", encoding="utf-8").writelines(lines)
    json.load(open(path, encoding="utf-8"))  # validate
print("ARBs updated + valid")

# ── 2. gen abstract ──
abs_path = os.path.join(DST, "gen", "app_localizations.dart")
lines = open(abs_path, encoding="utf-8").readlines()
anchor = next(i for i, l in enumerate(lines) if l.strip() == "String get forgotPassword;")
decl = []
for k in added:
    phs = placeholders_of(k)
    decl.append("\n")
    decl.append(f"  /// No description provided for @{k}.\n  ///\n")
    decl.append(f"  /// In en, this message translates to:\n")
    decl.append(f"  /// **'{dart_str(src_en[k])}'**\n")
    if phs:
        args = ", ".join(f"{t} {n}" for n, t in phs)
        decl.append(f"  String {k}({args});\n")
    else:
        decl.append(f"  String get {k};\n")
lines[anchor+1:anchor+1] = decl
open(abs_path, "w", encoding="utf-8").writelines(lines)
print(f"abstract: +{len(added)} declarations")

# ── 3. gen concrete ──
for loc, fn in ARB.items():
    src = json.load(open(os.path.join(SRC, fn), encoding="utf-8"))
    gen_fn = os.path.join(DST, "gen", f"app_localizations_{loc}.dart")
    lines = open(gen_fn, encoding="utf-8").readlines()
    a = next(i for i, l in enumerate(lines) if l.strip().startswith("String get forgotPassword =>"))
    block = []
    for k in added:
        phs = placeholders_of(k)
        v = src.get(k, src_en[k])
        block.append("\n  @override\n")
        if phs:
            args = ", ".join(f"{t} {n}" for n, t in phs)
            names = [n for n, _ in phs]
            block.append(f"  String {k}({args}) {{\n    return '{dart_body(v, names)}';\n  }}\n")
        else:
            block.append(f"  String get {k} => '{dart_str(v)}';\n")
    lines[a+1:a+1] = block
    open(gen_fn, "w", encoding="utf-8").writelines(lines)
print(f"concrete: +{len(added)} overrides x 11 locales")
print("DONE")
