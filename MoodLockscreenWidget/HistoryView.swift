import SwiftUI

struct HistoryView: View {
    @Environment(MoodStore.self) private var store

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("History")
                    .font(.title2)

                Text("Today’s entries: \(store.entries(on: Date()).count)")
                    .font(.subheadline)

                Text("Total entries: \(store.entries.count)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    let store = MoodStore()
    return HistoryView()
        .environment(store)
}
