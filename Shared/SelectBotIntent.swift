import AppIntents
import WidgetKit

// MARK: - Entity

struct BotNameEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Bot Name"
    static var defaultQuery = BotNameQuery()

    var id: String { name }
    let name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

// MARK: - Query

struct BotNameQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [BotNameEntity] {
        BotsJsonFile.loadNames()
            .filter { identifiers.contains($0) }
            .map { BotNameEntity(name: $0) }
    }

    func suggestedEntities() async throws -> [BotNameEntity] {
        BotsJsonFile.loadNames().map { BotNameEntity(name: $0) }
    }

    func defaultResult() async -> BotNameEntity? {
        BotNameEntity(name: "Choose...")
    }
}

// MARK: - Intent

struct SelectBotIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Bot"
    static var description = IntentDescription("Choose a bot name for this widget.")

    @Parameter(title: "Bot Name", requestValueDialog: "Choose a bot for this widget")
    var botName: BotNameEntity?
}
