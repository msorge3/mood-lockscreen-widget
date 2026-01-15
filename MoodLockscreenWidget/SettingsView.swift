import SwiftUI

struct SettingsView: View {
    @AppStorage("moodScalePreference")
    private var moodScaleRawValue: String = MoodScalePreference.detailed.rawValue

    private var moodScale: MoodScalePreference {
        MoodScalePreference(rawValue: moodScaleRawValue) ?? .detailed
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Mood Scale") {
                    Picker("Mood Scale", selection: $moodScaleRawValue) {
                        ForEach(MoodScalePreference.allCases) { option in
                            Text(option.displayName)
                                .tag(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(explainerText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Emoji Set") {
                    Text("More emoji styles coming soon")
                        .foregroundStyle(.secondary)
                }

                Section("Reminders") {
                    Text("Daily reminder coming soon")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var explainerText: String {
        switch moodScale {
        case .simple:
            return "Simple mode uses three emojis (bad / okay / good) for fastest logging."
        case .detailed:
            return "Detailed mode uses five emojis for more nuanced mood trends."
        }
    }
}

#Preview {
    SettingsView()
}
