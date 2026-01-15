import Foundation

enum MoodLevel: Int, CaseIterable, Identifiable {
    case veryBad = 0
    case bad
    case neutral
    case good
    case veryGood

    var id: Int { rawValue }

    var emoji: String {
        switch self {
        case .veryBad: return "😫"
        case .bad:     return "☹️"
        case .neutral: return "😐"
        case .good:    return "🙂"
        case .veryGood:return "😄"
        }
    }

    var label: String {
        switch self {
        case .veryBad: return "Awful"
        case .bad:     return "Not great"
        case .neutral: return "Okay"
        case .good:    return "Good"
        case .veryGood:return "Great"
        }
    }
}

struct MoodEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: MoodLevel
}
