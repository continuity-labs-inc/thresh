fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Generate App Store screenshots for all devices

### ios screenshots_preview

```sh
[bundle exec] fastlane ios screenshots_preview
```

Generate screenshots and create HTML preview

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload screenshots to App Store Connect

### ios screenshots_and_upload

```sh
[bundle exec] fastlane ios screenshots_and_upload
```

Generate and upload screenshots in one step

### ios ui_tests

```sh
[bundle exec] fastlane ios ui_tests
```

Run UI tests only (no screenshots)

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app for testing

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
