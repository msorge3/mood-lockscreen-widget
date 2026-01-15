import SwiftUI

@main
struct MoodLockscreenWidgetApp: App {
    @State private var store = MoodStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
