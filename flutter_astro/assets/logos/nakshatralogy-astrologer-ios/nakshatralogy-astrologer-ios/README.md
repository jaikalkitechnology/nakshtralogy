# Nakshatralogy ASTROLOGER App — iOS App Icon Set

`AppIcon.appiconset/` contains 18 icon size variants for iPhone, iPad, App Store marketing.

## Why Different from User App
- **User app**: cosmic dark navy (#0A0A24)
- **Astrologer app**: deep saffron/maroon (#7C2D12)

Same brand mandala, distinct background — easier to find the right app on the home screen.

## Flutter Integration
Drop the entire `AppIcon.appiconset/` folder into:
`ios/Runner/Assets.xcassets/AppIcon.appiconset/` (replaces existing)

Or use `flutter_launcher_icons`:
```yaml
flutter_launcher_icons:
  ios: true
  image_path_ios: "assets/icons/nakshatralogy-astrologer-mandala-saffron-1024.png"
  remove_alpha_ios: true
```

iOS adds rounded corners automatically — never pre-round.
