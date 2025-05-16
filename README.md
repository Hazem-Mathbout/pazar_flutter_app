# Pazar – Flutter Mobile App

Welcome to **Pazar**, a Flutter-based mobile application. This repository contains the complete source code for the app, and is ready to be cloned, edited, and run on macOS using either an emulator or a physical device.

---

## 🚀 Getting Started

Follow these steps to set up and run the project on your MacBook.

---

## 🧰 Prerequisites

Before running the app, ensure the following tools are installed:

- **Flutter SDK**  
  Install: [flutter.dev/docs/get-started/install/macos](https://flutter.dev/docs/get-started/install/macos)

- **Xcode** (for iOS builds & emulator)  
  Install via App Store: [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)

- **Android Studio** (optional, for Android support)  
  Install: [developer.android.com/studio](https://developer.android.com/studio)

- **Command Line Tools**  
  Make sure `flutter`, `dart`, and `xcodebuild` are accessible in the terminal.

To verify installation:
```bash
flutter doctor
````

Make sure all checks pass or are fixable.

---

## 📁 Project Setup

Once prerequisites are installed:

1. **Clone the repo:**

   ```bash
   git clone https://github.com/yourusername/pazar.git
   cd pazar
   ```

2. **Install packages:**

   ```bash
   flutter pub get
   ```

3. **(Optional) Update CocoaPods dependencies (for iOS):**

   ```bash
   cd ios
   pod install
   cd ..
   ```

---

## 📱 Running the App

You can run the app on either:

### ✅ iOS Simulator (Emulator)

1. Open the iOS Simulator:

   ```bash
   open -a Simulator
   ```

2. Run the app:

   ```bash
   flutter run
   ```

### ✅ Real iPhone Device (macOS + Xcode only)

1. Connect your iPhone via USB.
2. Trust the computer from the iPhone if prompted.
3. Run the app:

   ```bash
   flutter devices   # Make sure your device appears in the list
   flutter run
   ```

**Note:** You may need to open the `ios/Runner.xcworkspace` file in Xcode and:

* Set your **Team** under *Signing & Capabilities*
* Set a valid **Bundle Identifier**
* Build once using the Xcode UI


## 🛠️ Troubleshooting

* If `pod install` fails, try:

  ```bash
  sudo arch -x86_64 gem install ffi
  arch -x86_64 pod install
  ```

* If the iPhone doesn’t show up:

  * Make sure the device is **unlocked**
  * Try `flutter doctor` for diagnostics
  * Open **Xcode > Preferences > Locations > Command Line Tools** and select your Xcode version

---

## 📦 Build APK / IPA

To create an APK (Android):

```bash
flutter build apk --release
```

To create an IPA (iOS, via Xcode):

* Open `ios/Runner.xcworkspace` in Xcode
* Archive and export from Xcode

---

## 📄 License

This project is private and owned by **Hazem Mathbout**.. Contact the owner for any usage or licensing requests.

---

## 📬 Contact

For any support or inquiries, reach out to:

📧 [hazemmathbout93@gmail.com](mailto:hazemmathbout93@gmail.com)

```