# Hindustani Jyotish — Android Icon Pack

Complete Android launcher icon set for the Hindustani Jyotish app, matching the reference wordmark design.

## Design

- **Background:** Saffron / bhagwa orange `#CE7000` (exact color from reference PDF)
- **Wordmark:** "hindustani" in Yatra One (Devanagari-styled Latin) + "JYOTISH" in Poppins Black, both in white
- **Icon element:** Bhagwa dhwaj (small triangular flag on a pole) on top of the wordmark
- **Style:** Matches the Adobe Illustrator artboard reference

## Directory Structure

```
android/
├── mipmap-mdpi/                   ← Legacy square icons (older Android)
│   ├── ic_launcher.png            (48×48)
│   ├── ic_launcher_round.png      (48×48, circle-masked)
│   └── ic_launcher_foreground.png (108×108, transparent, for adaptive)
├── mipmap-hdpi/                   (72×72 / 162×162)
├── mipmap-xhdpi/                  (96×96 / 216×216)
├── mipmap-xxhdpi/                 (144×144 / 324×324)
├── mipmap-xxxhdpi/                (192×192 / 432×432)
├── mipmap-anydpi-v26/             ← Adaptive icon definitions (Android 8+)
│   ├── ic_launcher.xml
│   └── ic_launcher_round.xml
├── values/
│   └── ic_launcher_background.xml ← Color resource for adaptive bg
├── adaptive/                      ← Standalone adaptive foreground/background PNGs
│   └── mipmap-*/                  (same 5 densities)
├── maskable/
│   └── ic_launcher_maskable_512.png  ← PWA / adaptive maskable icon
└── playstore/
    ├── ic_launcher_playstore.png     ← 512×512 for Play Store listing
    ├── hindustani_jyotish_wordmark_1024.png
    └── hindustani_jyotish_wordmark_2048.png
```

## Install in Android Studio Project

### Option A — Full drop-in (recommended)

Copy the entire structure into `app/src/main/res/`:

```bash
# From your Android project root
cp -r android/mipmap-* app/src/main/res/
cp -r android/mipmap-anydpi-v26 app/src/main/res/
cp android/values/ic_launcher_background.xml app/src/main/res/values/
```

### Option B — Manual copy

1. Copy each `mipmap-*/ic_launcher.png` and `ic_launcher_round.png` to matching `app/src/main/res/mipmap-*/` folders
2. Copy each `mipmap-*/ic_launcher_foreground.png` to matching folders
3. Copy `mipmap-anydpi-v26/*.xml` to `app/src/main/res/mipmap-anydpi-v26/`
4. Add the color to your `app/src/main/res/values/colors.xml`:
   ```xml
   <color name="ic_launcher_background">#CE7000</color>
   ```

### Verify AndroidManifest.xml

Your `AndroidManifest.xml` should reference the launcher icons:

```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:roundIcon="@mipmap/ic_launcher_round"
    ... >
```

## Icon Density Reference

| Density | Icon Size | Foreground | Use Case |
|---------|-----------|------------|----------|
| mdpi | 48×48 | 108×108 | Baseline (~160dpi) |
| hdpi | 72×72 | 162×162 | ~240dpi |
| xhdpi | 96×96 | 216×216 | ~320dpi |
| xxhdpi | 144×144 | 324×324 | ~480dpi |
| xxxhdpi | 192×192 | 432×432 | ~640dpi (Galaxy S / Pixel high-end) |
| Play Store | 512×512 | — | Store listing only |

## Adaptive Icon (Android 8.0+)

The adaptive icon consists of two layers:

- **Background:** Solid saffron `#CE7000` (defined as color resource)
- **Foreground:** White wordmark (flag + hindustani + JYOTISH) on transparent, sized to fit within the 66dp safe zone

The system applies masks (circle, squircle, rounded square, teardrop) depending on the device launcher, so the safe zone ensures nothing critical is cropped.

### Preview under different masks

See `android/adaptive/mask_preview.png` — shows how the icon looks under Circle, Squircle, Rounded, and Square launcher masks. All wordmark content stays inside the safe zone.

## Maskable Icon (PWA / Modern Android)

`android/maskable/ic_launcher_maskable_512.png` — 512×512 with 20% safe padding on all sides. Use this in your `manifest.json`:

```json
{
  "icons": [{
    "src": "/icons/ic_launcher_maskable_512.png",
    "sizes": "512x512",
    "type": "image/png",
    "purpose": "maskable"
  }]
}
```

## Play Store Icon

`android/playstore/ic_launcher_playstore.png` (512×512) — upload directly to Google Play Console under "Store listing → Graphic assets → App icon."

## Wordmark for Splash Screens / Marketing

`android/playstore/hindustani_jyotish_wordmark_2048.png` (2048×2048) and `_1024.png` (1024×1024) — use for splash screens, marketing collateral, website hero, etc.

## Colors

| Token | Hex | Use |
|-------|-----|-----|
| Saffron | `#CE7000` | Background, brand primary |
| White | `#FFFFFF` | Wordmark, flag |

## Fonts Used

- **"hindustani"** — Yatra One (Google Fonts) — Devanagari-style Latin
- **"JYOTISH"** — Poppins Black (Google Fonts) — bold geometric sans

Both are free / open-source (OFL license) and can be embedded in the app for splash screens.

---

**Note:** Icons are generated from a script (`build_icons.py` style) — if you want a specific tweak (different flag shape, tighter padding, different font weight), regenerate rather than editing individual PNGs.
