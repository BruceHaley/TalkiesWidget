import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Widget Bundle

@main
struct TalkiesWidgetBundle: WidgetBundle {
    var body: some Widget {
        TalkiesWidgetExtension()
    }
}

// MARK: - Timeline Entry

struct NameEntry: TimelineEntry {
    let date: Date
    let name: String?

    var deepLinkURL: URL? {
        guard let name = name,
              let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return nil }
        return URL(string: "talkies://bot?botName=\(encoded)")
    }
}

// MARK: - Timeline Provider

struct NameProvider: AppIntentTimelineProvider {
    typealias Intent = SelectBotIntent

    func placeholder(in context: Context) -> NameEntry {
        NameEntry(date: Date(), name: "Choose...")
    }

    func snapshot(for configuration: SelectBotIntent, in context: Context) async -> NameEntry {
        NameEntry(date: Date(), name: configuration.botName?.name)
    }

    func timeline(for configuration: SelectBotIntent, in context: Context) async -> Timeline<NameEntry> {
        let entry = NameEntry(date: Date(), name: configuration.botName?.name)
        return Timeline(entries: [entry], policy: .never)
    }
}

// MARK: - Unconfigured view (all sizes)

struct UnconfiguredView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1a1a2e"), Color(hex: "#16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 8) {
                Image("BotIconGray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text("Tap & hold to set up widget")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
    }
}

// MARK: - Small

struct TalkiesWidgetSmallView: View {
    let entry: NameEntry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1a1a2e"), Color(hex: "#16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 6) {
                Image("BotIconColor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text(entry.name ?? "")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
            }
            .padding(12)
        }
    }
}

// MARK: - Medium

struct TalkiesWidgetMediumView: View {
    let entry: NameEntry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1a1a2e"), Color(hex: "#16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            HStack(spacing: 16) {
                Image("BotIconColor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text(entry.name ?? "")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            .padding(20)
        }
    }
}

// MARK: - Large

struct TalkiesWidgetLargeView: View {
    let entry: NameEntry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1a1a2e"), Color(hex: "#16213e"), Color(hex: "#0f3460")],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(spacing: 16) {
                Spacer()
                Image("BotIconColor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Text(entry.name ?? "")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            .padding(24)
        }
    }
}

// MARK: - Entry View

struct TalkiesWidgetEntryView: View {
    var entry: NameEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if entry.name == nil {
            UnconfiguredView()
        } else {
            switch family {
            case .systemSmall:  TalkiesWidgetSmallView(entry: entry)
            case .systemMedium: TalkiesWidgetMediumView(entry: entry)
            case .systemLarge:  TalkiesWidgetLargeView(entry: entry)
            default:            TalkiesWidgetSmallView(entry: entry)
            }
        }
    }
}

// MARK: - Widget Configuration

struct TalkiesWidgetExtension: Widget {
    let kind: String = "TalkiesWidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectBotIntent.self,
            provider: NameProvider()
        ) { entry in
            TalkiesWidgetEntryView(entry: entry)
                .containerBackground(Color(hex: "#1a1a2e"), for: .widget)
                .widgetURL(entry.deepLinkURL)
        }
        .configurationDisplayName("TalkiesWidget")
        .description("Opens a bot in Talkies.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    TalkiesWidgetExtension()
} timeline: {
    NameEntry(date: .now, name: "Alex")
    NameEntry(date: .now, name: nil)
}

#Preview(as: .systemMedium) {
    TalkiesWidgetExtension()
} timeline: {
    NameEntry(date: .now, name: "Jordan")
}

#Preview(as: .systemLarge) {
    TalkiesWidgetExtension()
} timeline: {
    NameEntry(date: .now, name: "MrKnowItAll")
}
