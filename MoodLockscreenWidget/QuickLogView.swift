import SwiftUI

struct QuickLogView: View {
    var body: some View {
        NavigationStack {
            Text("Quick Log")
                .font(.title2)
                .padding()
                .navigationTitle("Log Mood")
        }
    }
}

#Preview {
    QuickLogView()
}
