import ComposableArchitecture
@testable import TCASharedState
import XCTest

final class TCASharedStateTests: XCTestCase {
    @MainActor
    func testIncrement() async throws {
        let store = TestStore(initialState: ContentReducer.State()) {
            ContentReducer()._printChanges()
        }

        let task = await store.send(.task)

        await store.send(.incrementFoo) {
            $0.foo = 1
        }

        await store.receive(.didIncrementFoo) {
            $0.bar = 1
        }

        await task.cancel()
        await store.finish()
    }
}
