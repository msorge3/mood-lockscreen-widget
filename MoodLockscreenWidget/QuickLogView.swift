import SwiftUI

struct QuickLogView: View {
    @Environment(MoodStore.self) private var store

    @AppStorage("moodScalePreference")
    private var moodScaleRawValue: String = MoodScalePreference.detailed.rawValue

    @State private var lastLogged: MoodLevel?
    @State private var justLogged = false
    @State private var showBanner = false
    @State private var todayCount: Int = 0

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

    private var streak: Int {
        store.currentStreak()
    }

    var body: some View {
        NavigationStack {
            ZStack {
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

                if showBanner {
                    LoggedBanner(streak: streak, todayCount: todayCount)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showBanner)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .navigationTitle("Log Mood")
        }
    }

    private func log(_ level: MoodLevel) {
        store.add(level: level)
        lastLogged = level
        justLogged = true

        todayCount = store.entries(on: Date()).count
        showBanner = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            justLogged = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showBanner = false
        }
    }
}

private struct LoggedBanner: View {
    let streak: Int
    let todayCount: Int

    private var streakText: String {
        if todayCount == 1 && streak == 1 {
            return "First log today"
        }
        if streak == 1 {
            return "Streak: 1 day"
        }
        return "Streak: \(streak) days"
    }

    private var todayText: String {
        if todayCount <= 1 {
            return "Today: 1 log"
        }
        return "Today: \(todayCount) logs"
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("Logged!")
                .font(.headline)

            Text("🔥")

            VStack(alignment: .leading, spacing: 2) {
                Text(streakText)
                    .font(.subheadline)
                Text(todayText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.white.opacity(0.15))
        )
        .shadow(radius: 10, y: 4)
    }
}

#Preview {
    let store = MoodStore()
    return QuickLogView()
        .environment(store)
}
