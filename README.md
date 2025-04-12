# 🎙️ GradReady Interview App
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An AI-powered mobile app built with Flutter that lets users practice interview questions using real-time voice transcription and AI-generated feedback.

## 🚀 Features
- 🎤 Real-time voice recording and transcription
- 🤖 Intelligent AI feedback on:
  - Clarity of speech
  - Tone and delivery
  - Use of filler words
  - Overall presentation quality
- 📋 Dynamic question generation based on job roles
- 🧠 Presentation mode with topic-based feedback
- 🔄 Continuous practice mode

## 📱 Platforms Supported
- 📱 Android
- 🍏 iOS
- 🖥 Web
- 🐧 Linux
- 🍎 macOS
- 🪟 Windows

## 🛠 Requirements
- Flutter SDK 3.7+
- Android Studio / VS Code
- Google API service account (for Speech-to-Text)
- Gemini API key from Google Ai Studio

## 📁 Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/rikue29/grad_ready.git
cd grad_ready
```

### 2. Environment Setup
Create a `.env` file in the project root:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. Google Speech-to-Text Configuration
1. Place your `service-account.json` in:
   ```
   assets/service-account.json
   ```
2. Update `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/service-account.json
   ```

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Run the App
```bash
flutter run
```

## 📚 API Setup

### 🔐 Gemini API (MakerSuite)
1. Go to https://makersuite.google.com
2. Get your API key
3. Add it to `.env` as shown above

### 🗣 Google Speech-to-Text
1. Go to https://console.cloud.google.com/
2. Create a project + enable Speech-to-Text API
3. Create a Service Account and download the JSON key
4. Save it as `assets/service-account.json`

## 🧪 Troubleshooting

### Voice Input Issues
If the app doesn't pick up your microphone:
- On Android emulator: Enable mic input in extended controls
- Use a real Android phone for best results

## 📸 Screenshots

<div align="center">
  <img src="assets/screenshots/app_preview.png" alt="App Preview" width="300">
</div>

## 🧑‍💻 Contributors
- Ariq Ulwan
- Nur Akmal
- Nurin Adni
- Shane Kennedy

Special thanks to KitaHack for the opportunity

## 📄 License
This project is open source and available under the MIT License.

## 📬 Feedback & Support
For any questions, feedback, or support, please open an issue in the repository.

## 🌟 Star the Project
If you find this project useful, please give it a star ⭐ on GitHub!
