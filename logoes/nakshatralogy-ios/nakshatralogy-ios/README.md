# Nakshatralogy — iOS App Icon Set

Complete iOS app icon set with all required sizes for Xcode asset catalog.

## Quick install

1. In Xcode, open `Assets.xcassets`
2. Delete the existing `AppIcon` set
3. Drag the entire `AppIcon.appiconset` folder into `Assets.xcassets`
4. Done — all sizes auto-detected via Contents.json

## File breakdown

| Filename | Size | Used for |
|----------|------|----------|
| icon-20x20@2x.png | 40×40 | iPhone Notification |
| icon-20x20@3x.png | 60×60 | iPhone Plus Notification |
| icon-29x29@2x.png | 58×58 | iPhone Settings |
| icon-29x29@3x.png | 87×87 | iPhone Plus Settings |
| icon-40x40@2x.png | 80×80 | iPhone Spotlight |
| icon-40x40@3x.png | 120×120 | iPhone Plus Spotlight |
| icon-60x60@2x.png | 120×120 | iPhone App icon |
| icon-60x60@3x.png | 180×180 | iPhone Plus App icon |
| icon-20x20@1x.png | 20×20 | iPad Notification |
| icon-20x20@2x.png | 40×40 | iPad Notification (Retina) |
| icon-29x29@1x.png | 29×29 | iPad Settings |
| icon-29x29@2x.png | 58×58 | iPad Settings (Retina) |
| icon-40x40@1x.png | 40×40 | iPad Spotlight |
| icon-40x40@2x.png | 80×80 | iPad Spotlight (Retina) |
| icon-76x76@1x.png | 76×76 | iPad App icon |
| icon-76x76@2x.png | 152×152 | iPad App icon (Retina) |
| icon-83.5x83.5@2x.png | 167×167 | iPad Pro App icon |
| icon-1024x1024@1x.png | 1024×1024 | App Store listing |

## Specifications

- **No transparency** — iOS renders icons on solid backgrounds (PNG with no alpha)
- **No rounded corners needed** — iOS auto-rounds at the OS level
- **Color profile** — sRGB recommended (already correct from Cairo SVG renderer)
- **Format** — PNG-24 with no alpha channel

## Flutter integration

For Flutter projects, use `flutter_launcher_icons` package:

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  ios: true
  image_path: "assets/icons/icon-1024x1024@1x.png"
```

Then run:
```bash
flutter pub get
dart run flutter_launcher_icons
```

This will generate all the required iOS sizes automatically from the 1024 source.
