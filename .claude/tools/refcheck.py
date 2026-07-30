import sys,re
appdir=sys.argv[1]
abs_txt=open(f"{appdir}/lib/l10n/gen/app_localizations.dart").read()
avail=set(re.findall(r'String\s+get\s+(\w+)',abs_txt))|set(re.findall(r'String\s+(\w+)\(',abs_txt))
appcol=open(f"{appdir}/lib/theme/app_theme.dart").read()
defcol=set(re.findall(r'static\s+(?:const|final)?\s*Color\s+(\w+)',appcol))
ui=open(f"{appdir}/lib/screens/kundli/widgets/kundli_ui.dart").read()
kcdef=set(re.findall(r'static\s+const\s+Color\s+(\w+)',ui))|set(re.findall(r'static\s+Color\s+(\w+)',ui))
skip={'dart','toString','withOpacity','clamp','toUpperCase','toStringAsFixed','contains','isEmpty','isNotEmpty','map','where','toList','first','last','value','key','length','abs','round','floor','ceil','toInt','toDouble','add','entries','keys','values','cast','join','split','trim','sort','reversed','take','any','every','index','name','of','instance','elementAt','indexWhere','indexOf','substring','whereType','compareTo','replaceAll','generate','forEach','reduce','sign','fold','addAll','contains'}
for fn in sys.argv[2:]:
    src=open(f"{appdir}/{fn}").read()
    refs=re.findall(r'\bl\.(\w+)',src)
    miss=sorted(set(r for r in refs if r not in avail and r not in skip))
    cols=set(re.findall(r'AppColors\.(\w+)',src)); badc=sorted(c for c in cols if c not in defcol)
    kcs=set(re.findall(r'KColors\.(\w+)',src)); badk=sorted(c for c in kcs if c not in kcdef)
    b=fn.split('/')[-1]
    print(f"{b}: l.*={miss or 'OK'} | AppColors={badc or 'OK'} | KColors={badk or 'OK'}")
