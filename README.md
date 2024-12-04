# KTViewModelBuilder
A macro to use inside a Kotlin multiplatform for wrapping a Kotlin ViewModel into a SwiftUI ObservableObject, based on the [SKIE library](https://skie.touchlab.co/).

The goal of this macro is to increase the iOS development experience by removing the complexity of using a Kotlin ViewModel inside an iOS application written in Swift.

For example, instead of using KotlinInt/KotlinInt?, we're using Int/Int?, it can work with Float/Double/...

Note: the macro creates a unidirectional binding as usually used on Kotlin MVVM, so use can't directly SwiftUI `@Binding`.

## Example

### Kotlin ViewModel

A Kotlin ViewModel shared between Android and iOS with Observable content and methods.

```kotlin
public class ExampleViewModel : ViewModel() {

    private val _stringData = MutableStateFlow("Some Data")
    public val stringData: StateFlow<String> = _stringData

    private val _intNullableData = MutableStateFlow<Int?>(null)
    public val intNullableData: StateFlow<Int?> = _intNullableData

    private val _randomValue = MutableStateFlow(0)
    public val randomValue: StateFlow<Int> = _randomValue

    private val _entityData = MutableStateFlow<MyData?>(MyData())
    public val entityData: StateFlow<MyData?> = _entityData

    public fun randomizeValue() {
        _randomValue.value = (0..100).random()
    }
}
```

### SwiftUI ViewModel

The macro generate a SwiftUI ViewModel from the content of the Kotlin `ExampleViewModel` class.

```swift
@ktViewModel(ofType: ExampleViewModel.self,
                 publishing:
                    (\.stringData, String.self),
                 (\.intNullableData, Int?.self),
                 (\.randomValue, Double.self),
                 (\.entityData, MyData?.self)
)
class SharedExampleViewModel : ObservableObject {}
```

### SwiftUi View

The properties of the ViewModel can be directly used from the `viewModel` property and the method from `viewModel.instance`.

The binding must be triggered from a SwiftUI task modifier; it will start the Observability of the declared properties.

```swift
struct ExampleScreen: View {
    
    // Initialize the ViewModel, binding and lifecycle
    @StateObject var viewModel = SharedExampleViewModel(ExampleViewModel())
    
    var body: some View {
        VStack {
            Text("STRING VALUE \(viewModel.stringData)")
            Text("NULL VALUE \(String(describing: viewModel.intNullableData))")
            Text("RANDOM VALUE \(viewModel.randomValue)")
            Button {
                viewModel.instance.randomizeValue()
            } label: {
                Text("randomizeValue")
            }
        }.task {
            // start the ViewModel lifecycle and keep it alive until the view disappear
            await viewModel.start()
        }
    }
}
```

### The macro
<details>
<summary>The generated content</summary>
[Sources](https://github.com/frankois944/KTViewModelBuilder/blob/main/Tests/KTViewModelBuilderTests/KTViewModelBuilderTests.swift)
```swift
@sharedViewModel(ofType: MainScreenViewModel.self,
                 publishing: 
    (\\.mainScreenUIState, MainScreenUIState.self), 
    (\\.userId, String?.self),
    (\\.intNotValue, Int.self),
    (\\.intNullValue, Int?.self)
)
class MainScreenVM: ObservableObject {}
""",
expandedSource: """
class MainScreenVM: ObservableObject {

    private let viewModelStore = ViewModelStore()

    @Published private(set) var mainScreenUIState: MainScreenUIState

    @Published private(set) var userId: String?

    @Published private(set) var intNotValue: Int

    @Published private(set) var intNullValue: Int?

    init(_ viewModel: MainScreenViewModel) {
        self.viewModelStore.put(key: "MainScreenViewModelKey", viewModel: viewModel)
        self.mainScreenUIState = viewModel.mainScreenUIState.value
        print("INIT mainScreenUIState : " + String(describing: viewModel.mainScreenUIState.value))
        self.userId = viewModel.userId.value
        print("INIT userId : " + String(describing: viewModel.userId.value))
        self.intNotValue = viewModel.intNotValue.value.intValue
        print("INIT intNotValue : " + String(describing: viewModel.intNotValue.value))
        self.intNullValue = viewModel.intNullValue.value?.intValue
        print("INIT intNullValue : " + String(describing: viewModel.intNullValue.value))
    }

    var instance: MainScreenViewModel {
        self.viewModelStore.get(key: "MainScreenViewModelKey") as! MainScreenViewModel
    }

    func start() async {
        await withTaskGroup(of: (Void).self) {
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.mainScreenUIState where self != nil {
                    if value != self?.mainScreenUIState {
                        #if DEBUG
                        print("UPDATING mainScreenUIState : " + String(describing: value))
                        #endif
                        self?.mainScreenUIState = value
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.userId where self != nil {
                    if value != self?.userId {
                        #if DEBUG
                        print("UPDATING userId : " + String(describing: value))
                        #endif
                        self?.userId = value
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.intNotValue where self != nil {
                    if value.intValue != self?.intNotValue {
                        #if DEBUG
                        print("UPDATING intNotValue : " + String(describing: value))
                        #endif
                        self?.intNotValue = value.intValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.intNullValue where self != nil {
                    if value?.intValue != self?.intNullValue {
                        #if DEBUG
                        print("UPDATING intNullValue : " + String(describing: value))
                        #endif
                        self?.intNullValue = value?.intValue
                    }
                }
            }
        }
    }

    deinit {
        self.viewModelStore.clear()
    }
}
```
</details>


## Requirement

As this solution is based on Kotlin multiplatform and SKIE, some requirements need to be met.

### import SKIE library

Please follow the [installation step](https://skie.touchlab.co/intro#installation) of the library.

### add and export the kotlin ViewModel to Swift

- Add in your .toml or .gradle the following dependency

```toml
androidx-lifecycle-viewmodel = { module = "androidx.lifecycle:lifecycle-viewmodel", version.ref = "androidx_lifecycle_version" }
```

- Then follow this configuration or equivalent

```gradle
listOf(
    iosX64(),
    iosArm64(),
    iosSimulatorArm64()
).forEach {
    it.binaries.framework {
        baseName = "shared"
        isStatic = true
        export(libs.androidx.lifecycle.viewmodel) // !! export the library for the iOS target, so it can be accessible from swift code !!
    }
}

sourceSets {
    commonMain.dependencies {
        api(libs.androidx.lifecycle.viewmodel) // the library itself
    }
}
```

## Conclusion

That's all we need. 

A [Sample](https://github.com/frankois944/KTViewModelBuilder/tree/main/Sample) has a shared library, an iOS/Android app.
