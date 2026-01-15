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

    /// Average mood level for a given day, rounded to the closest emoji, if any entries exist.
    func representativeLevel(for day: Date, calendar: Calendar = .current) -> MoodLevel? {
        let dayEntries = entries(on: day, calendar: calendar)
        guard !dayEntries.isEmpty else { return nil }

        let sum = dayEntries
            .map { $0.level.rawValue }
            .reduce(0, +)

        let avgDouble = Double(sum) / Double(dayEntries.count)
        let avgRaw = Int(avgDouble.rounded())

        // Rounded to nearest mood level, or fall back to last entry of the day
        return MoodLevel(rawValue: avgRaw)
            ?? dayEntries.last?.level
    }

    /// Current streak in days: consecutive days ending today with at least one entry.
    func currentStreak(calendar: Calendar = .current) -> Int {
        let today = calendar.startOfDay(for: Date())

        // If no entries today, streak is 0.
        guard !entries(on: today, calendar: calendar).isEmpty else {
            return 0
        }

        var streak = 0
        var cursor = today

        while true {
            let dayEntries = entries(on: cursor, calendar: calendar)
            if dayEntries.isEmpty {
                break
            }
            streak += 1

            // Move one day back.
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previousDay
        }

        return streak
    }

    /// Whether there is at least one entry on the given calendar day.
    func hasEntries(on day: Date, calendar: Calendar = .current) -> Bool {
        !entries(on: day, calendar: calendar).isEmpty
    }
}
