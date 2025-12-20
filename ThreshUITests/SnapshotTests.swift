import XCTest

/// UI Tests for generating App Store screenshots using Fastlane Snapshot
/// Run with: fastlane screenshots
final class SnapshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        // Pass launch argument to enable demo mode with sample data
        app.launchArguments = ["-uitesting"]
        setupSnapshot(app)
        app.launch()

        // Wait for app to fully load
        sleep(2)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Screenshot Tests

    /// Screen 1: Home screen showing reflections list
    func test01_HomeScreen() throws {
        // App should launch to home screen with demo data
        // Wait for content to load
        let reflectionsList = app.scrollViews.firstMatch
        XCTAssertTrue(reflectionsList.waitForExistence(timeout: 5))

        snapshot("01_HomeScreen")
    }

    /// Screen 2: New Reflection capture screen
    func test02_NewReflection() throws {
        // Tap on "New Reflection" button
        let newReflectionButton = app.buttons["New Reflection"]
        if newReflectionButton.waitForExistence(timeout: 3) {
            newReflectionButton.tap()
        } else {
            // Try finding by image
            let cameraButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Reflection'")).firstMatch
            if cameraButton.exists {
                cameraButton.tap()
            }
        }

        // Wait for the capture screen to appear
        sleep(1)

        snapshot("02_NewReflection")
    }

    /// Screen 3: Extraction modal showing AI-extracted items
    /// Note: This requires demo mode to pre-populate or simulate extraction
    func test03_Extraction() throws {
        // This screenshot may need to be captured differently
        // since extraction happens after saving a reflection.
        // For now, we'll skip to the next available screen.

        // Navigate back to home if needed
        let backButton = app.navigationBars.buttons.firstMatch
        if backButton.exists {
            backButton.tap()
            sleep(1)
        }

        // Try to find an existing reflection and tap it to see details
        let reflectionRow = app.buttons.matching(NSPredicate(format: "label CONTAINS '#'")).firstMatch
        if reflectionRow.waitForExistence(timeout: 3) {
            reflectionRow.tap()
            sleep(1)
            snapshot("03_ReflectionDetail")
        }
    }

    /// Screen 4: Patterns screen (sparkles button)
    func test04_Patterns() throws {
        // Go back to home screen first
        navigateToHome()

        // Find and tap the sparkles/patterns button in toolbar
        let sparklesButton = app.buttons["sparkles"]
        if sparklesButton.waitForExistence(timeout: 3) {
            sparklesButton.tap()
        } else {
            // Try navigation bar button
            let navSparkles = app.navigationBars.buttons.matching(NSPredicate(format: "identifier CONTAINS 'sparkles' OR label CONTAINS 'Patterns'")).firstMatch
            if navSparkles.exists {
                navSparkles.tap()
            }
        }

        sleep(1)
        snapshot("04_Patterns")
    }

    /// Screen 5: Weekly Synthesis screen
    func test05_WeeklySynthesis() throws {
        navigateToHome()

        // Find and tap Weekly Synthesis
        let weeklySynthesis = app.buttons["Weekly Synthesis"]
        if weeklySynthesis.waitForExistence(timeout: 3) {
            weeklySynthesis.tap()
        } else {
            // Try scrolling to find it
            let scrollView = app.scrollViews.firstMatch
            scrollView.swipeUp()

            let weeklyButton = app.staticTexts["Weekly Synthesis"]
            if weeklyButton.waitForExistence(timeout: 2) {
                weeklyButton.tap()
            }
        }

        sleep(1)
        snapshot("05_WeeklySynthesis")
    }

    /// Screen 6: Stories tab
    func test06_Stories() throws {
        navigateToHome()

        // Tap on Stories tab
        let storiesTab = app.buttons["Stories"]
        if storiesTab.waitForExistence(timeout: 3) {
            storiesTab.tap()
            sleep(1)
            snapshot("06_Stories")
        }
    }

    /// Screen 7: Ideas tab
    func test07_Ideas() throws {
        navigateToHome()

        // Tap on Ideas tab
        let ideasTab = app.buttons["Ideas"]
        if ideasTab.waitForExistence(timeout: 3) {
            ideasTab.tap()
            sleep(1)
            snapshot("07_Ideas")
        }
    }

    /// Screen 8: Questions tab
    func test08_Questions() throws {
        navigateToHome()

        // Tap on Questions tab
        let questionsTab = app.buttons["Questions"]
        if questionsTab.waitForExistence(timeout: 3) {
            questionsTab.tap()
            sleep(1)
            snapshot("08_Questions")
        }
    }

    /// Screen 9: Settings screen
    func test09_Settings() throws {
        navigateToHome()

        // Find and tap Settings button (gear icon)
        let settingsButton = app.buttons["gearshape"]
        if settingsButton.waitForExistence(timeout: 3) {
            settingsButton.tap()
        } else {
            // Try by accessibility identifier or label
            let gearButton = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'settings' OR identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
            if gearButton.exists {
                gearButton.tap()
            }
        }

        sleep(1)
        snapshot("09_Settings")
    }

    /// Screen 10: Paywall screen (required for IAP review)
    func test10_Paywall() throws {
        navigateToHome()

        // Navigate to Settings first
        let settingsButton = app.buttons["gearshape"]
        if settingsButton.waitForExistence(timeout: 3) {
            settingsButton.tap()
            sleep(1)
        } else {
            let gearButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
            if gearButton.exists {
                gearButton.tap()
                sleep(1)
            }
        }

        // Find and tap the subscription/upgrade row
        let upgradeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Upgrade' OR label CONTAINS 'Thresh Free'")).firstMatch
        if upgradeButton.waitForExistence(timeout: 3) {
            upgradeButton.tap()
            sleep(1)
            snapshot("10_Paywall")
        } else {
            // Try scrolling to find subscription section
            let list = app.tables.firstMatch
            if list.exists {
                list.swipeUp()
            }

            let subscriptionCell = app.cells.matching(NSPredicate(format: "label CONTAINS 'Subscription' OR label CONTAINS 'extractions'")).firstMatch
            if subscriptionCell.waitForExistence(timeout: 2) {
                subscriptionCell.tap()
                sleep(1)
                snapshot("10_Paywall")
            }
        }
    }

    /// Screen 11: iPad Sidebar view (iPad only)
    func test11_iPadSidebar() throws {
        // This test is specifically for iPad to capture the sidebar layout
        // On iPhone, this will capture home screen instead

        // Wait for the app to settle
        sleep(1)

        // Check if we're on iPad by looking for sidebar/split view elements
        let sidebarList = app.tables.matching(NSPredicate(format: "identifier CONTAINS 'sidebar'")).firstMatch
        if sidebarList.waitForExistence(timeout: 2) {
            // We're on iPad with sidebar visible
            snapshot("11_iPadSidebar")
        } else {
            // On iPhone, capture an alternate home view
            navigateToHome()
            snapshot("11_HomeAlternate")
        }
    }

    // MARK: - Helper Methods

    /// Navigate back to the home screen
    private func navigateToHome() {
        // Keep pressing back until we're at home
        for _ in 0..<5 {
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists && backButton.isHittable {
                // Check if it's a back button (chevron or "Back")
                let label = backButton.label.lowercased()
                if label.contains("back") || label.contains("chevron") || label.isEmpty {
                    backButton.tap()
                    sleep(1)
                } else {
                    break
                }
            } else {
                break
            }
        }
    }
}

// MARK: - Snapshot Helper

/// Setup function required by Fastlane Snapshot
/// This is called automatically when using `setupSnapshot(app)`
func setupSnapshot(_ app: XCUIApplication, waitForAnimations: Bool = true) {
    Snapshot.setupSnapshot(app, waitForAnimations: waitForAnimations)
}
