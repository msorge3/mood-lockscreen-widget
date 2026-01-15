import SwiftUI

struct TrendsView: View {
    @Environment(MoodStore.self) private var store

    private let calendar = Calendar.current
    private let lookbackDays = 14

    private var recentDays: [Date] {
        let today = calendar.startOfDay(for: Date())
        return (0..<lookbackDays).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }
        .reversed()
    }

    private var streak: Int {
        store.currentStreak(calendar: calendar)
    }

    private var daysWithLogsCount: Int {
        recentDays.filter { store.hasEntries(on: $0, calendar: calendar) }.count
    }

    private var consistencyMessage: String {
        if daysWithLogsCount == 0 {
            return "No logs in the last \(lookbackDays) days yet."
        } else if daysWithLogsCount <= lookbackDays / 3 {
            return "Several missing days — logging a bit more often helps trends."
        } else if daysWithLogsCount < lookbackDays {
            return "Nice work — you’re logging on many days. Keep the streak going."
        } else {
            return "Strong streak — you’ve logged every day recently."
        }
    }

    private var streakMessage: String {
        if streak == 0 {
            return "Streak: none yet"
        } else if streak == 1 {
            return "Streak: 1 day"
        } else {
            return "Streak: \(streak) days"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SignalsCard(
                        title: "Signals",
                        consistency: consistencyMessage,
                        streak: streakMessage
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last \(lookbackDays) Days")
                            .font(.headline)

                        Text("Each day shows your overall mood.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        RecentDaysStrip(
                            days: recentDays,
                            calendar: calendar
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Trends")
        }
    }
}

private struct SignalsCard: View {
    let title: String
    let consistency: String
    let streak: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(consistency)
                .font(.subheadline)

            Text(streak)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.white.opacity(0.08))
        )
    }
}

private struct RecentDaysStrip: View {
    @Environment(MoodStore.self) private var store

    let days: [Date]
    let calendar: Calendar

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(days, id: \.self) { day in
                    let emoji = store.representativeLevel(for: day, calendar: calendar)?.emoji
                    let isToday = calendar.isDateInToday(day)

                    VStack(spacing: 4) {
                        Text(emoji ?? "–")
                            .font(.title2)
                            .foregroundStyle(emoji == nil ? .secondary : .primary)

                        Text(dayLabel(for: day))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 32)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(
                                isToday ? Color.blue.opacity(0.8) : Color.gray.opacity(0.25),
                                lineWidth: isToday ? 2 : 1
                            )
                    )
                }
            }
            .padding(.top, 4)
        }
    }

    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

#Preview {
    let store = MoodStore()
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    for offset in 0..<5 {
        if let day = calendar.date(byAdding: .day, value: -offset, to: today) {
            store.add(level: .good, at: day)
        }
    }

    return TrendsView()
        .environment(store)
}
