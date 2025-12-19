# Fastlane Screenshot Automation for Thresh

This directory contains Fastlane configuration for generating App Store Connect screenshots.

## Prerequisites

1. **Install Fastlane** (if not already installed):
   ```bash
   brew install fastlane
   ```

2. **Add UI Test Target to Xcode Project**:
   - Open `Thresh.xcodeproj` in Xcode
   - File → New → Target
   - Select "UI Testing Bundle"
   - Name it "ThreshUITests"
   - Add `SnapshotTests.swift` and `SnapshotHelper.swift` from `ThreshUITests/` folder

## Commands

### Generate All Screenshots
```bash
cd /Users/drewnat/Documents/ContinuityLabsGit/thresh
fastlane screenshots
```

This will:
- Launch simulators for each device size
- Run UI tests with demo data
- Capture screenshots at each test step
- Save to `./fastlane/screenshots/`

### Generate Screenshots with Frame/Preview
```bash
fastlane screenshots_preview
```

Generates screenshots and adds device frames for preview.

### Upload Screenshots to App Store Connect
```bash
fastlane upload_screenshots
```

Uploads screenshots to App Store Connect using the API key.

### Generate and Upload in One Step
```bash
fastlane screenshots_and_upload
```

## Device Sizes

Screenshots are captured for:

| Device | Display Size | App Store Slot |
|--------|-------------|----------------|
| iPhone 16 Pro Max | 6.9" | Required |
| iPhone 15 Pro Max | 6.7" | 6.5" slot |
| iPhone 8 Plus | 5.5" | Legacy |
| iPad Pro 12.9" (6th gen) | 12.9" | Required |
| iPad Pro 12.9" (2nd gen) | 12.9" | Legacy |

## Screenshots Captured

1. **01_HomeScreen** - Main screen with reflections list
2. **02_NewReflection** - Capture screen
3. **03_ReflectionDetail** - Detail view of a reflection
4. **04_Patterns** - Patterns/Sparkles screen
5. **05_WeeklySynthesis** - Weekly synthesis view
6. **06_Stories** - Stories tab
7. **07_Ideas** - Ideas tab
8. **08_Questions** - Questions tab

## Demo Data

When the app is launched with `-uitesting` argument:
- Uses in-memory database (clean state)
- Automatically skips onboarding
- Seeds attractive demo data including:
  - 5 reflections (1 marked as "holding")
  - 2 stories (1 extracted, 1 user-created)
  - 2 ideas (1 extracted, 1 user-created)
  - 3 questions (2 extracted, 1 user-created)

## Troubleshooting

### Screenshots are blank or show loading
- Increase `sleep()` times in `SnapshotTests.swift`
- Check that demo data is being seeded properly

### UI elements not found
- Update element identifiers in test cases
- Use Xcode's Accessibility Inspector to find correct identifiers

### Build errors
- Ensure ThreshUITests target is properly configured
- Check that SnapshotHelper.swift is included in the test target

## File Structure

```
fastlane/
├── Appfile          # App configuration
├── Fastfile         # Lane definitions
├── Snapfile         # Screenshot configuration
├── README.md        # This file
└── screenshots/     # Generated screenshots (after running)

ThreshUITests/
├── SnapshotTests.swift    # UI test cases
└── SnapshotHelper.swift   # Fastlane helper (from fastlane repo)
```

## App Store Connect API Key

The API key for uploading is located at:
```
/Users/drewnat/Documents/ContinuityLabsGit/secrets/AuthKey_VU9M7VJ4XL.p8
```

You may need to create `api_key.json` with your key details:
```json
{
  "key_id": "VU9M7VJ4XL",
  "issuer_id": "YOUR_ISSUER_ID",
  "key_filepath": "/Users/drewnat/Documents/ContinuityLabsGit/secrets/AuthKey_VU9M7VJ4XL.p8"
}
```
