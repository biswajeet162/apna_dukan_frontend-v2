# Pre-Build Checklist for Android APK

Follow these steps **before building** your Android APK to ensure a clean, fresh build:

## ✅ Step-by-Step Pre-Build Process

### 1. **Navigate to Frontend Directory**
```bash
cd apna_dukan_frontend
```

### 2. **Clean Build Cache (IMPORTANT!)**
This removes all cached build artifacts and ensures a fresh build:
```bash
flutter clean
```

**Why?** This prevents old cached files from being used, which causes the "old version" issue.

### 3. **Get Dependencies**
Ensure all Flutter packages are up to date:
```bash
flutter pub get
```

### 4. **Verify Backend URL**
Check that `lib/app/app_config.dart` has the correct production URL:
- Production: `https://apna-dukan-backend-v2-v6w4.onrender.com`
- The config defaults to production, so you're good to go!

### 5. **Check Flutter Doctor (Optional but Recommended)**
Verify your Flutter setup is correct:
```bash
flutter doctor
```

Make sure:
- ✅ Flutter is installed
- ✅ Android toolchain is set up
- ✅ Device is connected (if testing)

### 6. **Uninstall Old App from Device (If Testing)**
If you're installing on a device, uninstall the old version first:
```bash
adb uninstall com.example.apna_dukan_frontend
```

Or manually uninstall from your phone's settings.

## 🚀 Build Commands

### For Debug APK (Development/Testing)
```bash
# Option 1: Manual
flutter clean
flutter build apk --debug --dart-define=ENV=prod

# Option 2: Use Script (Windows)
build-android-debug.bat

# Option 3: Use Script (Linux/Mac)
./build-android-debug.sh
```

### For Release APK (Production)
```bash
# Option 1: Manual
flutter clean
flutter build apk --release --dart-define=ENV=prod

# Option 2: Use Script (Windows)
build-android-prod.bat

# Option 3: Use Script (Linux/Mac)
./build-android-prod.sh
```

## 📍 APK Locations

After building, find your APK at:
- **Debug**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release**: `build/app/outputs/flutter-apk/app-release.apk`

## 🔍 Quick Verification

After building, verify the APK is fresh:
1. Check the file modification timestamp - it should be recent
2. Check the file size - should match previous builds (not significantly smaller)
3. Install and check the app logs show: `Running in prod environment`
4. Check the API Base URL in logs: `https://apna-dukan-backend-v2-v6w4.onrender.com/api`

## ⚠️ Common Issues & Solutions

### Issue: Still seeing old version
**Solution**: 
1. Run `flutter clean` again
2. Delete the `build/` folder manually
3. Rebuild

### Issue: Build fails
**Solution**:
1. Run `flutter pub get` again
2. Check `flutter doctor` for setup issues
3. Try `flutter build apk --debug` without flags first

### Issue: APK not installing
**Solution**:
1. Uninstall old app completely
2. Enable "Install from Unknown Sources" on Android
3. Try `flutter install` instead of manual install

## 📝 Summary - Quick Reference

**Minimum required steps before EVERY build:**
```bash
cd apna_dukan_frontend
flutter clean          # ← CRITICAL: Always do this first!
flutter pub get        # ← Ensure dependencies are updated
flutter build apk --debug --dart-define=ENV=prod
```

Or simply use the build script (does clean automatically):
```bash
build-android-debug.bat    # Windows
./build-android-debug.sh   # Linux/Mac
```



