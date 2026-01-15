import SwiftUI

struct DayDetailView: View {
    @Environment(MoodStore.self) private var store

    let date: Date
    private let calendar = Calendar.current

    private var dayEntries: [MoodEntry] {
        store.entries(on: date, calendar: calendar)
            .sorted { $0.timestamp < $1.timestamp }
    }

    private var representativeLevel: MoodLevel? {
        store.representativeLevel(for: date, calendar: calendar)
    }

    var body: some View {
        List {
            if dayEntries.isEmpty {
                Section {
                    Text("No moods logged this day yet.")
                        .foregroundStyle(.secondary)
                }
            } else {
                Section {
                    if let representativeLevel {
                        HStack(spacing: 12) {
                            Text(representativeLevel.emoji)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Overall: \(representativeLevel.label)")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    ForEach(dayEntries) { entry in
                        HStack(spacing: 12) {
                            Text(entry.level.emoji)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(timeString(for: entry.timestamp))
                                    .font(.subheadline)

                                Text(entry.level.label)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(shortDateTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var shortDateTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    private func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // e.g. "3:24 PM"
        return formatter.string(from: date)
    }
}

#Preview {
    let store = MoodStore()
    let calendar = Calendar.current
    let today = Date()

    store.add(level: .good, at: today)
    if let later = calendar.date(byAdding: .hour, value: 3, to: today) {
        store.add(level: .veryGood, at: later)
    }

    return NavigationStack {
        DayDetailView(date: today)
            .environment(store)
    }
}
