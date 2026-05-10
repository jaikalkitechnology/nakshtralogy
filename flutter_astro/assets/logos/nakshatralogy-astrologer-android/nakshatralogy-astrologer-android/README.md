# Nakshatralogy ASTROLOGER App — Android Adaptive Icon

## Files
- `ic_launcher_foreground.png` (432×432, transparent edges, gold mandala)
- `ic_launcher_background.png` (saffron/maroon gradient + starfield)
- `ic_launcher_monochrome.png` (white silhouette for Android 13+ themed icons)
- `ic_launcher.xml` — adaptive icon drawable resource
- `preview-circle-mask.png`, `preview-squircle-mask.png` — preview previews

## Why Different from User App
The User app uses **cosmic dark navy** (#0A0A24) background.
This Astrologer app uses **deep saffron/maroon** (#7C2D12) background.
Same Nakshatralogy mandala, but visually distinct on the user's home screen so they don't confuse the two.

## Flutter Integration
Place files in `android/app/src/main/res/mipmap-xxxhdpi/`, resize for other densities,
or use `flutter_launcher_icons` with this config in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "ic_launcher"
  image_path_android: "assets/icons/ic_launcher_foreground.png"
  adaptive_icon_background: "assets/icons/ic_launcher_background.png"
  adaptive_icon_foreground: "assets/icons/ic_launcher_foreground.png"
  adaptive_icon_monochrome: "assets/icons/ic_launcher_monochrome.png"
```
