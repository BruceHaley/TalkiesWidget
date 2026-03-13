import Foundation

/// Reads and writes the list of bot names to/from bots.json
/// stored in the shared App Group container.
struct BotsJsonFile {
    static let appGroupID = "group.com.bhh.talkies"

    // MARK: - Container URL

    static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }

    static var botsFileURL: URL? {
        containerURL?.appendingPathComponent("bots.json")
    }

    // MARK: - Read

    static func loadNames() -> [String] {
        guard let url = botsFileURL,
              let data = try? Data(contentsOf: url),
              let names = try? JSONDecoder().decode([String].self, from: data)
        else {
            return defaultNames()
        }
        return names
    }

    // MARK: - Write

    @discardableResult
    static func saveNames(_ names: [String]) -> Bool {
        guard let url = botsFileURL,
              let data = try? JSONEncoder().encode(names)
        else { return false }
        do {
            try data.write(to: url, options: .atomic)
            return true
        } catch {
            print("BotsJsonFile write error: \(error)")
            return false
        }
    }

    // MARK: - Seed defaults if file absent

    static func seedIfNeeded() {
        guard let url = botsFileURL,
              !FileManager.default.fileExists(atPath: url.path)
        else { return }
        saveNames(defaultNames())
    }

    // MARK: - Defaults

    static func defaultNames() -> [String] {
        ["Alex", "Jordan", "Morgan", "Taylor", "Casey",
         "Riley", "Quinn", "Avery", "Dakota", "Skyler",
         "Jamie", "Reese", "Peyton", "Finley", "Blake"]
    }
}
