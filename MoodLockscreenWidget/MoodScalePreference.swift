import Foundation

enum MoodScalePreference: String, CaseIterable, Identifiable {
    case simple
    case detailed

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .simple:   return "Simple (3 emojis)"
        case .detailed: return "Detailed (5 emojis)"
        }
    }
}
