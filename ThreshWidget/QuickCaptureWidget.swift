import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Quick Capture App Intent

/// App Intent for launching Quick Capture from widget
struct QuickCaptureIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Capture"
    static var description = IntentDescription("Open Quick Capture to instantly capture a thought")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        // The app will handle the deep link via URL scheme
        return .result()
    }
}

// MARK: - Widget Timeline

struct QuickCaptureProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuickCaptureEntry {
        QuickCaptureEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (QuickCaptureEntry) -> Void) {
        let entry = QuickCaptureEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuickCaptureEntry>) -> Void) {
        let entry = QuickCaptureEntry(date: Date())
        // Static widget, no updates needed
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct QuickCaptureEntry: TimelineEntry {
    let date: Date
}

// MARK: - Widget View

struct QuickCaptureWidgetEntryView: View {
    var entry: QuickCaptureProvider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .accessoryCircular:
            accessoryCircularWidget
        case .accessoryRectangular:
            accessoryRectangularWidget
        default:
            smallWidget
        }
    }

    // MARK: - Small Widget

    private var smallWidget: some View {
        VStack(spacing: 8) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 32))
                .foregroundStyle(captureColor)

            Text("Quick Capture")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            Text("Tap to capture")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            Color(red: 0.12, green: 0.12, blue: 0.14)
        }
    }

    // MARK: - Medium Widget

    private var mediumWidget: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(captureColor.opacity(0.2))
                    .frame(width: 56, height: 56)

                Image(systemName: "bolt.fill")
                    .font(.title2)
                    .foregroundStyle(captureColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Quick Capture")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("What's on your mind? Just capture it.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(red: 0.12, green: 0.12, blue: 0.14)
        }
    }

    // MARK: - Lock Screen Widgets

    private var accessoryCircularWidget: some View {
        ZStack {
            AccessoryWidgetBackground()
            Image(systemName: "bolt.fill")
                .font(.title2)
        }
    }

    private var accessoryRectangularWidget: some View {
        HStack {
            Image(systemName: "bolt.fill")
                .font(.title3)
            VStack(alignment: .leading) {
                Text("Quick Capture")
                    .font(.headline)
                Text("Tap to capture")
                    .font(.caption)
            }
        }
    }

    private var captureColor: Color {
        Color(red: 0.95, green: 0.6, blue: 0.2)
    }
}

// MARK: - Widget Configuration

struct QuickCaptureWidget: Widget {
    let kind: String = "QuickCaptureWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickCaptureProvider()) { entry in
            QuickCaptureWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Capture")
        .description("Instantly capture thoughts with one tap.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

// MARK: - Widget Bundle

@main
struct ThreshWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuickCaptureWidget()
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    QuickCaptureWidget()
} timeline: {
    QuickCaptureEntry(date: .now)
}

#Preview(as: .systemMedium) {
    QuickCaptureWidget()
} timeline: {
    QuickCaptureEntry(date: .now)
}
