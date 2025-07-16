## 📱 QR Code Scanner App (Flutter)

A powerful and easy-to-use **QR Code Scanner** app built with **Flutter**, featuring modern UI and essential functionality. This app allows users to scan QR codes instantly, view scan history, and generate new QR codes with custom data.

---

### ✨ Features

* 📷 **Scan QR Codes** in real-time using the device camera
* 🕓 **Scan History** to view previously scanned QR codes
* 📟 **Generate QR Codes** from custom text or links
* 💡 Supports **light/dark mode**
* 📂 **Locally stores** history using [Hive](https://pub.dev/packages/hive)
* ⚡ Fast performance and clean architecture using **Bloc/Cubit**

---

### 🧱 Project Structure

This project follows a Clean Architecture pattern:

```
lib/
🔗 core/         # Shared resources and helpers
🔗 features/
🔗 scan/     # Scan QR code logic
🔗 history/  # Scan history logic
🔗 generate/ # QR code generation
🔗 main.dart
```

---

### 🚀 Getting Started

To run this app locally:

```bash
git clone https://github.com/AmrSalahDev/qr_code_scanner_flutter.git
cd qr_code_scanner_flutter
flutter pub get
flutter run
```

---

### 🛆 Dependencies

* [`qr_code_scanner_plus`](https://pub.dev/packages/qr_code_scanner_plus)
* [`hive`](https://pub.dev/packages/hive)
* [`flutter_bloc`](https://pub.dev/packages/flutter_bloc)
* [`path_provider`](https://pub.dev/packages/path_provider)
* [`qr_flutter`](https://pub.dev/packages/qr_flutter)

---

### 📸 Screenshots

> Add screenshots here (Scan page, History page, Generate page)

---

### 🛠️ Contributions

Feel free to fork the repo, open issues, or submit PRs to improve the app!
