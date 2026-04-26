# ✅ Task Manager App — Flutter + Back4App (BaaS)

> **BITS Pilani MTECH WILP | Mobile Application Development Assignment**
> A Flutter-based CRUD Task Manager powered by Back4App as Backend-as-a-Service.

---

## 🎥 Demo Video

▶️ **[Watch on YouTube](https://youtu.be/w_vLLz0slWM)**

> 2-minute demo covering: Registration → Login → Create Task → Update Task → Delete Task → Logout → Back4App database verification

---

## 🚀 Features

| Feature | Details |
|---------|---------|
| **User Registration** | Sign up with student email & password via Back4App Auth |
| **User Login** | Persistent session — no re-login after app restart |
| **Create Task** | Title + description stored in Back4App cloud DB |
| **Read Tasks** | Fetched in real-time, ordered by creation date |
| **Update Task** | Edit title/description or toggle completion status |
| **Delete Task** | Delete with confirmation dialog |
| **Secure Logout** | Session invalidated on Back4App server |
| **Tab Filters** | View All / Pending / Completed tasks |
| **Task Stats** | Live count of Total, Pending, and Done tasks |

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.x (Dart) |
| Backend | Back4App (Hosted Parse Server) |
| Database | Back4App Cloud Database |
| Authentication | Back4App Parse User Auth |
| Version Control | GitHub |

---

## ⚙️ How to Run — GitHub Codespaces (No Installation Needed!)

This is the easiest way to run the app directly in your browser without installing anything.

### Step 1 — Open in Codespaces

1. Go to **https://github.com/gurudeepmallam-cmd/taskmanager**
2. Click the green **"Code"** button
3. Click the **"Codespaces"** tab
4. Click **"Create codespace on main"**
5. Wait for Codespaces to load (takes about 1 minute)

---

### Step 2 — Install Flutter inside Codespaces

Once Codespaces opens, you will see a terminal at the bottom. Run these commands **one by one**:

```bash
git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
```
> ⏳ This takes 2-3 minutes. Wait for it to finish completely.

```bash
export PATH="$PATH:$HOME/flutter/bin"
```

```bash
flutter precache
```
> ⏳ This takes another 2-3 minutes. Wait for it to finish.

---

### Step 3 — Add Your Back4App Keys

```bash
cat > /workspaces/taskmanager/task_manager_app/lib/config/back4app_config.dart << 'EOF'
class Back4AppConfig {
  static const String applicationId  = 'YOUR_APPLICATION_ID';
  static const String clientKey      = 'YOUR_CLIENT_KEY';
  static const String parseServerUrl = 'https://parseapi.back4app.com';
}
EOF
```

> 🔑 Replace `YOUR_APPLICATION_ID` and `YOUR_CLIENT_KEY` with your Back4App keys.
> Get your keys from: **back4app.com → Your App → App Settings → Security & Keys**

---

### Step 4 — Navigate to Project & Install Dependencies

```bash
cd /workspaces/taskmanager/task_manager_app
```

```bash
flutter pub get
```

---

### Step 5 — Add Web Support

```bash
flutter create . --platforms web
```

---

### Step 6 — Run the App

```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

> ⏳ Wait about 30-40 seconds for the app to compile.

---

### Step 7 — Open in Browser

1. Look at the bottom of Codespaces — click the **"PORTS"** tab
2. Find port **8080** in the list
3. Click the **🌐 globe icon** next to it
4. Your app opens in a new browser tab!

> If no popup appears, look for a notification saying **"Your application running on port 8080 is available"** and click **"Open in Browser"**

---

### Step 8 — Use the App

1. Click **"Register"** → sign up with your email and password
2. You will be taken to **"My Tasks"** screen
3. Click **"New Task"** button (bottom right) to create a task
4. Fill in Title and Description → click **"Add Task"**
5. Use the **✏️ edit** and **🗑️ delete** buttons on each task card
6. Click the **logout icon** (top right) to sign out

---

### 💡 Tips for Codespaces

- Every time you open a **new terminal**, run this to restore Flutter:
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

- To **hot reload** after code changes, press **`r`** in the terminal where flutter is running

- To **restart** the app, press **`R`** (capital R)

- To **quit**, press **`q`**

- The Codespaces URL changes every session — always use the URL from the **PORTS tab**, not a saved old URL

---

## ⚙️ How to Run — Local Machine (Windows)

### Prerequisites

| Tool | Download Link |
|------|--------------|
| Flutter SDK | https://flutter.dev/docs/get-started/install/windows |
| Git | https://git-scm.com/download/win |
| Android Studio | https://developer.android.com/studio |

### Step 1 — Clone the Repository

```bash
git clone https://github.com/gurudeepmallam-cmd/taskmanager.git
cd taskmanager/task_manager_app
```

### Step 2 — Add Flutter to PATH

1. Extract Flutter ZIP to `C:\flutter`
2. Press `Windows key` → search **"Environment Variables"**
3. Under User variables → click **Path** → **Edit** → **New**
4. Type `C:\flutter\bin` → click **OK**
5. Open a **new** CMD window

### Step 3 — Add Back4App Keys

Open `lib/config/back4app_config.dart` and paste your keys:

```dart
class Back4AppConfig {
  static const String applicationId = 'YOUR_APPLICATION_ID';
  static const String clientKey     = 'YOUR_CLIENT_KEY';
  static const String parseServerUrl = 'https://parseapi.back4app.com';
}
```

### Step 4 — Run

```bash
flutter pub get
flutter run
```

> Make sure an Android emulator is running in Android Studio before running this command.

---

## 🔑 Getting Back4App Keys

1. Go to **https://www.back4app.com** → Log in
2. Click on your app **TaskManagerApp**
3. In the left sidebar → **App Settings → Security & Keys**
4. Copy:
   - **Application ID**
   - **Client Key**
5. Paste them into `lib/config/back4app_config.dart`

---

## ✅ Verify Back4App Connection

After registering and creating a task:
1. Go to **https://dashboard.back4app.com**
2. Open your app → **Database → Browser**
3. You should see:
   - `_User` class — your registered users
   - `Task` class — your created tasks

This confirms real-time cloud sync is working! ✅

---

## 📁 Project Structure

```
lib/
├── config/
│   └── back4app_config.dart       # App ID, Client Key, Server URL
├── models/
│   └── task_model.dart            # Task data model
├── services/
│   ├── auth_service.dart          # Register, Login, Logout
│   └── task_service.dart          # CRUD operations via Parse SDK
├── screens/
│   ├── splash_screen.dart         # Animated splash + session routing
│   ├── login_screen.dart          # Sign in UI
│   ├── register_screen.dart       # Sign up UI
│   ├── task_list_screen.dart      # Main screen with tabs & stats
│   └── task_form_screen.dart      # Add / Edit task bottom sheet
├── widgets/
│   ├── custom_text_field.dart     # Reusable input field
│   └── task_card.dart             # Task card with edit/delete buttons
├── theme/
│   └── app_theme.dart             # Colors, typography, themes
└── main.dart                      # Entry point + Parse SDK init
```

---

## 🗄️ Back4App Database Schema

| Column | Type | Description |
|--------|------|-------------|
| `objectId` | String | Auto-generated unique ID |
| `title` | String | Task title |
| `description` | String | Task description |
| `isCompleted` | Boolean | Completion status |
| `ACL` | ACL | Owner-only access control |
| `createdAt` | Date | Auto-set on creation |
| `updatedAt` | Date | Auto-set on every update |

---

## 👨‍💻 Author

| | |
|--|--|
| **Name** | Gurudeep Mallam |
| **ID** | 2024MT13121 |
| **Email** | 2024mt13121@wilp.bits-pilani.ac.in |
| **Program** | BITS Pilani MTECH WILP |

---

## 📄 License

This project is submitted as part of academic coursework at BITS Pilani. All rights reserved by the author.
