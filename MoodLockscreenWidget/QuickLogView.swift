import SwiftUI

struct QuickLogView: View {
    @Environment(MoodStore.self) private var store

    @AppStorage("moodScalePreference")
    private var moodScaleRawValue: String = MoodScalePreference.detailed.rawValue

    @State private var lastLogged: MoodLevel?
    @State private var justLogged = false

    private var moodScale: MoodScalePreference {
        MoodScalePreference(rawValue: moodScaleRawValue) ?? .detailed
    }

    private var visibleLevels: [MoodLevel] {
        switch moodScale {
        case .detailed:
            return MoodLevel.allCases
        case .simple:
            return [.veryBad, .neutral, .veryGood]
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("How are you feeling?")
                    .font(.headline)

                if let lastLogged {
                    Text(lastLogged.emoji)
                        .font(.system(size: 72))
                } else {
                    Text("🙂")
                        .font(.system(size: 72))
                        .foregroundStyle(.secondary)
                }

                Text(lastLogged?.label ?? "Tap an emoji to log your mood")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 16) {
                    ForEach(visibleLevels) { level in
                        Button {
                            log(level)
                        } label: {
                            Text(level.emoji)
                                .font(.system(size: 36))
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(level == lastLogged ? Color.blue.opacity(0.2) : .clear)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                if justLogged {
                    Text("Logged!")
                        .font(.footnote)
                        .foregroundStyle(.green)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Log Mood")
        }
    }

    private func log(_ level: MoodLevel) {
        store.add(level: level)
        lastLogged = level
        justLogged = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            justLogged = false
        }
    }
}

#Preview {
    let store = MoodStore()
    return QuickLogView()
        .environment(store)
}
