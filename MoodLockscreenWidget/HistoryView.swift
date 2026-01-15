import SwiftUI

struct HistoryView: View {
    @Environment(MoodStore.self) private var store

    private let calendar = Calendar.current

    // Current month we’re showing. For now: always “this month”.
    private var monthStart: Date {
        let now = Date()
        return calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
    }

    private var monthNameAndYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // e.g., "September 2026"
        return formatter.string(from: monthStart)
    }

    /// All dates in the current month.
    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else {
            return []
        }

        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }

    /// How many empty cells we need before the 1st, so weekday headers align.
    private var leadingEmptyDays: Int {
        guard let firstDay = daysInMonth.first else { return 0 }
        let weekday = calendar.component(.weekday, from: firstDay)
        // Make Sunday = 1 → index 0; convert to count of empties before first day
        return weekday - calendar.firstWeekday
            >= 0 ? weekday - calendar.firstWeekday : 7 - (calendar.firstWeekday - weekday)
    }

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Month title
                Text(monthNameAndYear)
                    .font(.title2)
                    .bold()

                // Weekday headers
                weekdayHeader

                // Calendar grid
                LazyVGrid(columns: columns, spacing: 8) {
                    // Empty leading cells
                    ForEach(0..<leadingEmptyDays, id: \.self) { _ in
                        Color.clear.frame(height: 40)
                    }

                    // Actual days
                    ForEach(daysInMonth, id: \.self) { day in
                        DayCell(
                            date: day,
                            emoji: store.representativeLevel(for: day, calendar: calendar)?.emoji,
                            isToday: calendar.isDateInToday(day)
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
        }
    }

    private var weekdayHeader: some View {
        let symbols = calendar.shortWeekdaySymbols // e.g. ["Sun", "Mon", ...]
        let firstWeekdayIndex = max(calendar.firstWeekday - 1, 0)
        let rotatedSymbols = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])

        return HStack {
            ForEach(rotatedSymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct DayCell: View {
    let date: Date
    let emoji: String?
    let isToday: Bool

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.caption2)
                .foregroundStyle(.secondary)

            if let emoji {
                Text(emoji)
                    .font(.title3)
            } else {
                // Empty state for days with no logs
                Text("•")
                    .font(.caption2)
                    .foregroundStyle(.clear)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isToday ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2), lineWidth: isToday ? 2 : 1)
        )
    }
}

#Preview {
    let store = MoodStore()
    // Seed a few fake entries for preview
    let calendar = Calendar.current
    if let today = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) {
        store.add(level: .good, at: today)
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
            store.add(level: .veryBad, at: yesterday)
            store.add(level: .neutral, at: yesterday)
        }
    }

    return HistoryView()
        .environment(store)
}
