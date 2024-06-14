import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<ContentReducer>

    var body: some View {
        VStack {
            Button("Increment Foo") { store.send(.incrementFoo) }
            Text("foo = \(store.foo)")
            Text("bar = \(store.bar)")
        }
        .monospaced()
        .padding()
        .task { store.send(.task) }
    }
}

@Reducer
struct ContentReducer {
    @ObservableState
    struct State: Equatable {
        @Shared(.appStorage("foo")) var foo = 0
        @Shared(.appStorage("bar")) var bar = 0
    }

    enum Action {
        case task
        case incrementFoo
        case didIncrementFoo
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementFoo:
                state.foo += 1
                return .none

            case .didIncrementFoo:
                state.bar += 1
                return .none

            case .task:
                return .publisher {
                    state.$foo.publisher.map { _ in
                        return .didIncrementFoo
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(
            initialState: ContentReducer.State(),
            reducer: {
                ContentReducer()._printChanges()
            }
        )
    )
    .frame(width: 200)
}
