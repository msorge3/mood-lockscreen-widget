import Foundation
import Observation

@Observable
class MoodStore {
    var entries: [MoodEntry] = []

    func add(level: MoodLevel, at date: Date = Date()) {
        let entry = MoodEntry(timestamp: date, level: level)
        entries.append(entry)
    }

    func entries(on day: Date, calendar: Calendar = .current) -> [MoodEntry] {
        entries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: day)
        }
    }

    /// Average mood level for a given day, if any entries exist.
    func representativeLevel(for day: Date, calendar: Calendar = .current) -> MoodLevel? {
        let dayEntries = entries(on: day, calendar: calendar)
        guard !dayEntries.isEmpty else { return nil }

        let sum = dayEntries
            .map { $0.level.rawValue }
            .reduce(0, +)
        let avgRaw = Int((Double(sum) / Double(dayEntries.count)).rounded())

        // Round to nearest MoodLevel
        return MoodLevel(rawValue: avgRaw)
            ?? dayEntries.last?.level // fallback to last of the day if something goes weird
    }
}
