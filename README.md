# 🎙️ GradReady Interview App

An AI-powered mobile app built with Flutter that lets users practice interview questions using real-time voice transcription and AI-generated feedback.

Powered by:
- ✅ Google Speech-to-Text API (for converting speech to text)
- ✅ Gemini AI (for generating questions and giving interview feedback)

---

## 📦 Features
- 🎤 Record your voice responses to interview questions or presentations
- 🤖 Get intelligent AI feedback on clarity, tone, and use of filler words
- 📋 Dynamically generate questions based on job roles
- 🧠 Present a topic and get reviewed on simplicity and audience understanding
- 🔄 Keep going with new questions or topics non-stop
---

## 🛠 Requirements
- Flutter SDK 3.7+
- Android Studio / VS Code
- A valid Google API service account (for Speech-to-Text)
- A Gemini MakerSuite API key

---

## 📁 Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/your-username/gradready-interview.git
cd gradready-interview
```

### 2. Add your `.env` file
Create a `.env` file in the project root:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. Add your Google Speech-to-Text service account key
Place your `service-speech-to-text.json` in:
```
assets/keys/service-speech-to-text.json
```

Update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/keys/service-speech-to-text.json
```

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Run the app
```bash
flutter run
```

---

## 📚 Environment & API Setup

### 🔐 Gemini API (MakerSuite)
1. Go to https://makersuite.google.com
2. Get your API key
3. Add it to `.env` as shown above

### 🗣 Google Speech-to-Text
1. Go to https://console.cloud.google.com/
2. Create a project + enable Speech-to-Text API
3. Create a **Service Account** and download the JSON key
4. Save it as `assets/keys/service-speech-to-text.json`

---

## ✨ Screenshots
(Insert screenshots of the UI here)

---

## 🧪 Test Voice Input
If the app doesn't pick up your mic:
- On Android emulator → Enable mic input in extended controls
- Use a real Android phone for best results

---

## 🧑‍💻 Contributors
- Ariq Ulwan, Nur Akmal, Nurin Adni, Shane Kennedy – idea, design, and full implementation
- Special thanks to KitaHack for the opportunity

---

## 📄 License
This project is open source and available under the MIT License.