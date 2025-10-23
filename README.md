
# 🦊 You App — Flutter Login Example with Dio & GetX

A simple Flutter project demonstrating **login functionality** using **Dio**, **GetX**, and **GetStorage**.  
This app uses a **hardcoded user account** for authentication and stores user data (including profile image placeholders) locally with GetStorage.  
Built with **Flutter 3.35.4**.

---

## 🚀 Features

- 🔐 Login using email, username, and password (hardcoded)  
- 💾 Local storage with **GetStorage** (for token & user data)  
- ⚙️ HTTP client setup with **Dio**  
- 🧠 State management using **GetX**  
- 🖼️ Profile image stored locally since image API is not available  
- 🎨 Simple & clean UI with Flutter Material Widgets  

---

## 🧰 Tech Stack

| Package | Description |
|----------|--------------|
| [Flutter 3.35.4](https://flutter.dev) | Cross-platform UI framework |
| [GetX](https://pub.dev/packages/get) | State management, routing, dependency injection |
| [Dio](https://pub.dev/packages/dio) | Powerful HTTP client for Dart/Flutter |
| [GetStorage](https://pub.dev/packages/get_storage) | Lightweight local key-value storage |

---

## 📦 Installation

1. **Clone this repository**
   ```bash
   git clone https://github.com/your-username/you_app.git
   cd you_app
2. flutter pub get
3. flutter run


for login use {
  "email": "lemur@gmail.com",
  "username": "lemur001",
  "password": "admin123"
}
because in this UI dont use username and then hardcode in front end but if you want to register use this account 

