import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuickLogView()
                .tabItem {
                    Image(systemName: "hand.point.up.left.fill")
                    Text("Log")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }

            TrendsView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Trends")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
