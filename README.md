# KTViewModelBuilder
A macro to use inside a Kotlin multiplatform project for wrapping a Kotlin ViewModel into a SwiftUI ObservableObject, based on the [SKIE library](https://skie.touchlab.co/).

The goal of this macro is to increase the iOS development experience by removing the complexity of using a Kotlin ViewModel inside an iOS application written in Swift and also respecting the Lifecycle.

For example, instead of using KotlinInt/KotlinInt?, we're using Int/Int?, it can work with Float/Double/...

Note: the macro creates a unidirectional binding as usually used on Kotlin MVVM, so we can't use directly SwiftUI `@Binding`.

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
<details>
<summary>Generated content</summary>

```swift
class SharedExampleViewModel : ObservableObject {
    private let viewModelStore = ViewModelStore()
    
    @Published private(set) var stringData: String
    
    @Published private(set) var intNullableData: Int?
    
    @Published private(set) var randomValue: Double
    
    @Published private(set) var entityData: MyData?
    
    init(_ viewModel: ExampleViewModel) {
        self.viewModelStore.put(key: "ExampleViewModelKey", viewModel: viewModel)
        self.stringData = viewModel.stringData.value
        print("INIT stringData : " + String(describing: viewModel.stringData.value))
        self.intNullableData = viewModel.intNullableData.value?.intValue
        print("INIT intNullableData : " + String(describing: viewModel.intNullableData.value))
        self.randomValue = viewModel.randomValue.value.doubleValue
        print("INIT randomValue : " + String(describing: viewModel.randomValue.value))
        self.entityData = viewModel.entityData.value
        print("INIT entityData : " + String(describing: viewModel.entityData.value))
    }
    
    var instance: ExampleViewModel {
        self.viewModelStore.get(key: "ExampleViewModelKey") as! ExampleViewModel
    }
    
    func start() async {
        await withTaskGroup(of: (Void).self) {
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.stringData where self != nil {
                    if value != self?.stringData {
                        #if DEBUG
                        print("UPDATING stringData : " + String(describing: value))
                        #endif
                        self?.stringData = value
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.intNullableData where self != nil {
                    if value?.intValue != self?.intNullableData {
                        #if DEBUG
                        print("UPDATING intNullableData : " + String(describing: value))
                        #endif
                        self?.intNullableData = value?.intValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.randomValue where self != nil {
                    if value.doubleValue != self?.randomValue {
                        #if DEBUG
                        print("UPDATING randomValue : " + String(describing: value))
                        #endif
                        self?.randomValue = value.doubleValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.entityData where self != nil {
                    if value != self?.entityData {
                        #if DEBUG
                        print("UPDATING entityData : " + String(describing: value))
                        #endif
                        self?.entityData = value
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

## Requirement

As this solution is based on Kotlin multiplatform and SKIE, some requirements need to be met.

### Import SKIE library

Please follow the [installation step](https://skie.touchlab.co/intro#installation) of the library.

### Add and export the kotlin ViewModel to Swift

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

### Add the macro to your xcode project.

Finally, add this package to your application swift package dependencies.

```
https://github.com/frankois944/KTViewModelBuilder
```

## Conclusion

That's all you need.

A [Sample](https://github.com/frankois944/KTViewModelBuilder/tree/main/Sample) is available in this repository, which has a shared library and an iOS/Android app.
