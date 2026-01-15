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
}
