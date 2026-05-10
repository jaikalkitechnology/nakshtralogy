# Nakshatralogy — Android Adaptive Icon

Three-layer adaptive icon for Android 13+ (also works on Android 8+).

## Files

| File | Purpose |
|------|---------|
| `ic_launcher_foreground.png` | Mandala logo (transparent edges, safe zone respected) |
| `ic_launcher_background.png` | Cosmic gradient background (full bleed) |
| `ic_launcher_monochrome.png` | White silhouette for Android 13+ themed icons |
| `ic_launcher.xml` | Drawable resource that combines all 3 layers |
| `preview-circle-mask.png` | What it looks like on devices using circular mask |
| `preview-squircle-mask.png` | What it looks like on devices using squircle mask |

## Flutter integration

1. Place the 3 PNG files in `android/app/src/main/res/drawable/`
2. Place `ic_launcher.xml` in `android/app/src/main/res/mipmap-anydpi-v26/`
3. Update `AndroidManifest.xml`:
   ```xml
   <application
       android:icon="@mipmap/ic_launcher"
       android:roundIcon="@mipmap/ic_launcher"
       ...
   ```

## Specifications

- Canvas: 432×432 px (108dp × 108dp at xxxhdpi)
- Safe zone: 264×264 px (66dp × 66dp) — content fits within this
- All masks (circle, squircle, rounded square, teardrop) crop to safe zone

## Tip
For a complete icon set across all densities (mdpi → xxxhdpi), use
Android Studio's "Image Asset Studio" with these 3 PNGs as input.
