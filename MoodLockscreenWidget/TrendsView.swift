import SwiftUI

struct TrendsView: View {
    var body: some View {
        NavigationStack {
            Text("Trends")
                .font(.title2)
                .padding()
                .navigationTitle("Trends")
        }
    }
}

#Preview {
    TrendsView()
}
