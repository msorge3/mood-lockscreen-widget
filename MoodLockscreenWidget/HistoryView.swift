import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            Text("History")
                .font(.title2)
                .padding()
                .navigationTitle("Calendar")
        }
    }
}

#Preview {
    HistoryView()
}
