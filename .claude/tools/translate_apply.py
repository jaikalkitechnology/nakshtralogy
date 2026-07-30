#!/usr/bin/env python3
"""
Apply a translation map to a locale: rewrite its ARB (in en key order) and
regenerate that locale's generated concrete delegate from the ARBs.

- ARB: rebuilt as { "@@locale": loc, <en-key-order>: translated|existing|en }.
  Non-English ARBs are normalized to flat JSON (valid, complete, en-ordered).
- gen concrete (app_localizations_<loc>.dart): header preserved verbatim up to
  the first getter; all getters/methods regenerated from ARB values, using en
  ARB @placeholders metadata for method signatures. Matches flutter gen-l10n.

Usage: python3 translate_apply.py --app flutter_user --locale bn transmap.json
"""
import json, sys, os, html

def arg(name, default=None):
    return sys.argv[sys.argv.index(name)+1] if name in sys.argv else default

APP = arg("--app", "flutter_user")
LOC = arg("--locale")
transfile = [a for a in sys.argv[1:] if not a.startswith("-")
             and a not in (APP, LOC)][0]
L10N = f"/home/user/nakshtralogy/{APP}/lib/l10n"
GEN = f"{L10N}/gen"

trans = json.load(open(transfile, encoding="utf-8"))
trans = {k: html.unescape(v) for k, v in trans.items() if isinstance(v, str)}
en = json.load(open(f"{L10N}/app_en.arb", encoding="utf-8"))
loc = json.load(open(f"{L10N}/app_{LOC}.arb", encoding="utf-8"))

# en key order + placeholder metadata
en_keys = [k for k in en if not k.startswith("@")]
def placeholders(k):
    meta = en.get("@"+k) or {}
    ph = meta.get("placeholders") or {}
    return [(name, (spec or {}).get("type", "Object")) for name, spec in ph.items()]

# ── 1. rebuild locale ARB in en order ──
new_loc = {"@@locale": LOC}
applied = 0
for k in en_keys:
    if k in trans:
        new_loc[k] = trans[k]; applied += 1
    elif k in loc:
        new_loc[k] = loc[k]
    else:
        new_loc[k] = en[k]  # last-resort interim (shouldn't happen post-translate)
with open(f"{L10N}/app_{LOC}.arb", "w", encoding="utf-8") as f:
    json.dump(new_loc, f, ensure_ascii=False, indent=2)
    f.write("\n")

# ── 2. regenerate concrete gen ──
def dstr(s):
    return s.replace("\\", "\\\\").replace("\n", "\\n").replace("'", "\\'")
def dbody(s, names):
    s = dstr(s)
    for n in names:
        s = s.replace("{"+n+"}", "${"+n+"}")
    return s

gen_path = f"{GEN}/app_localizations_{LOC}.dart"
src = open(gen_path, encoding="utf-8").read()
idx = src.index("  @override")           # header = everything before first getter
header = src[:idx].rstrip() + "\n"
out = [header]
for k in en_keys:
    v = new_loc[k]
    phs = placeholders(k)
    out.append("\n  @override\n")
    if phs:
        args = ", ".join(f"{t} {n}" for n, t in phs)
        names = [n for n, _ in phs]
        out.append(f"  String {k}({args}) {{\n    return '{dbody(v, names)}';\n  }}\n")
    else:
        out.append(f"  String get {k} => '{dstr(v)}';\n")
out.append("}\n")
open(gen_path, "w", encoding="utf-8").write("".join(out))

# validate
json.load(open(f"{L10N}/app_{LOC}.arb", encoding="utf-8"))
g = open(gen_path, encoding="utf-8").read()
assert g.count("{") == g.count("}"), "brace imbalance in " + gen_path
print(f"{APP}/{LOC}: applied {applied} translations; ARB={len(en_keys)} keys; gen regenerated ✓")
