# ✅ Task Manager App — Flutter + Back4App (BaaS)

> **BITS Pilani MTECH WILP | Mobile Application Development Assignment**
> A production-ready Flutter CRUD application powered by Back4App Backend-as-a-Service.

---

## 📱 App Screenshots

| Splash | Login | Register |
|--------|-------|----------|
| _Animated gradient splash with session check_ | _Email/password sign in_ | _Student email registration_ |

| Task List | Add Task | Edit Task |
|-----------|----------|-----------|
| _Tabs: All / Pending / Done + stats_ | _Bottom sheet form_ | _Pre-filled edit form_ |

---

## 🚀 Features

| Feature | Details |
|---------|---------|
| **User Registration** | Sign up with email & password via Back4App Auth |
| **User Login** | Persistent session (no re-login after app restart) |
| **Create Task** | Title + description stored in Back4App cloud DB |
| **Read Tasks** | Real-time fetch, ordered by creation date |
| **Update Task** | Edit title/description or toggle completion |
| **Delete Task** | Swipe-to-delete with confirmation dialog |
| **Secure Logout** | Session invalidated on Back4App server |
| **Tab Filters** | View All / Pending / Completed tasks |
| **Task Stats** | Live count of Total, Pending, and Done tasks |
| **Swipe Actions** | Slide left on any task to reveal Edit / Delete |

---

## 🛠️ Technology Stack

```
Frontend  :  Flutter 3.x (Dart)
Backend   :  Back4App (Hosted Parse Server)
Database  :  Back4App Cloud Database (MongoDB-backed)
Auth      :  Back4App Parse User Authentication
SDK       :  parse_server_sdk_flutter ^8.0.0
VCS       :  GitHub
```

---

## 📁 Project Structure

```
lib/
├── config/
│   └── back4app_config.dart     # App ID, Client Key, Server URL
├── models/
│   └── task_model.dart          # Task data model
├── services/
│   ├── auth_service.dart        # Register, Login, Logout, Session check
│   └── task_service.dart        # CRUD operations via Parse SDK
├── screens/
│   ├── splash_screen.dart       # Animated splash + session routing
│   ├── login_screen.dart        # Sign in UI
│   ├── register_screen.dart     # Sign up UI
│   ├── task_list_screen.dart    # Main screen with tabs & stats
│   └── task_form_screen.dart    # Add / Edit task bottom sheet
├── widgets/
│   ├── custom_text_field.dart   # Reusable input field
│   └── task_card.dart          # Slidable task card
├── theme/
│   └── app_theme.dart           # Colors, typography, component themes
└── main.dart                    # Entry point + Parse SDK init
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK ≥ 3.0.0 installed ([flutter.dev](https://flutter.dev))
- A Back4App account ([back4app.com](https://www.back4app.com))
- Android Studio / VS Code with Flutter extension

### Step 1 — Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/task-manager-flutter-back4app.git
cd task-manager-flutter-back4app
```

### Step 2 — Create a Back4App App

1. Go to [back4app.com](https://www.back4app.com) → **Create new app**
2. Name it `TaskManagerApp` (or any name)
3. Navigate to **App Settings → Security & Keys**
4. Copy your **Application ID** and **Client Key**

### Step 3 — Configure API Keys

Open `lib/config/back4app_config.dart` and replace the placeholder values:

```dart
class Back4AppConfig {
  static const String applicationId = 'YOUR_BACK4APP_APPLICATION_ID'; // ← paste here
  static const String clientKey    = 'YOUR_BACK4APP_CLIENT_KEY';      // ← paste here
  static const String parseServerUrl = 'https://parseapi.back4app.com';
}
```

### Step 4 — Install Dependencies

```bash
flutter pub get
```

### Step 5 — Run the App

```bash
# Check connected devices
flutter devices

# Run on Android emulator or physical device
flutter run

# Build APK for release
flutter build apk --release
```

---

## 🗄️ Back4App Database Schema

The app automatically creates the `Task` class in your Back4App dashboard when the first task is saved. No manual schema setup required.

| Column | Type | Description |
|--------|------|-------------|
| `objectId` | String | Auto-generated unique ID |
| `title` | String | Task title |
| `description` | String | Task description |
| `isCompleted` | Boolean | Completion status |
| `ACL` | ACL | Restricts access to the owner user only |
| `createdAt` | Date | Auto-set on creation |
| `updatedAt` | Date | Auto-set on every save |

---

## 🔄 App Flow Diagram

```
App Launch
    │
    ▼
SplashScreen ──► Session valid? ──Yes──► TaskListScreen
                       │
                      No
                       │
                       ▼
                  LoginScreen ◄──────────────────────────────┐
                       │                                      │
              Register link                              Logout button
                       │                                      │
                       ▼                                      │
                RegisterScreen                         TaskListScreen
                       │                                  │
              Signup success                     ┌─────────────────────┐
                       │                         │  CRUD Operations    │
                       └────────────────────────►│                     │
                                                 │  Create → FAB       │
                                                 │  Read   → List      │
                                                 │  Update → Swipe/tap │
                                                 │  Delete → Swipe     │
                                                 └─────────────────────┘
```

---

## 📦 Dependencies

```yaml
parse_server_sdk_flutter: ^8.0.0   # Back4App / Parse Server client
google_fonts: ^6.1.0               # Poppins typeface
flutter_slidable: ^3.1.0           # Swipe-to-action on task cards
animate_do: ^3.3.4                 # Screen entry animations
flutter_staggered_animations: ^1.1.1 # Staggered list animations
intl: ^0.19.0                      # Date formatting
shared_preferences: ^2.2.2        # Local key-value storage
fluttertoast: ^8.2.4               # Toast messages
```

---

## 🔐 Security Notes

- Each task's ACL is set to **owner-only**, so users can only see their own tasks.
- Passwords are hashed and stored securely by Back4App — never stored in plain text.
- Session tokens are managed by the Parse SDK and persisted securely on-device.
- `debug: true` in `Parse().initialize()` should be set to `false` before production release.

---

## 🎥 Demo Video

📺 **YouTube Link:** [https://youtu.be/YOUR_VIDEO_ID](https://youtu.be/YOUR_VIDEO_ID)

> The 2-minute demo covers: Registration → Login → Create Task → Update Task → Delete Task → Logout

---

## 👨‍💻 Author

| | |
|--|--|
| **Name** | Your Name |
| **ID** | Your Student ID |
| **Program** | BITS Pilani MTECH WILP |
| **Cert** | eWPTX |

---

## 📄 License

This project is submitted as part of academic coursework at BITS Pilani. All rights reserved by the author.
