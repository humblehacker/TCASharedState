import ComposableArchitecture
import SwiftUI

@main
struct TCASharedStateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: ContentReducer.State(),
                    reducer: {
                        ContentReducer()._printChanges()
                    }
                )
            )
        }
    }
}
