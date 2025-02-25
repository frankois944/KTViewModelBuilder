# KTViewModelBuilder
A macro to use inside a Kotlin multiplatform project for wrapping a Kotlin ViewModel into a SwiftUI ObservableObject, based on the [SKIE library](https://skie.touchlab.co/).

The goal of this macro is to increase the iOS development experience by removing the complexity of using a Kotlin ViewModel inside an iOS application written in Swift and also respecting the Lifecycle.

For example, instead of using KotlinInt/KotlinInt?, we're using Int/Int?, it can work with Float/Double/...

Currently supported Kotlin types : dataclass/class, int, double, float, bool, uint, Long (swift int64), please make an issue for more.

> [!NOTE]  
> The macro can create uniderectional and bidirectionel binding

See the [sample](https://github.com/frankois944/KTViewModelBuilder/tree/main/Sample) for a full example.

## Example

### Kotlin ViewModel

```kotlin
public class ExampleViewModel : ViewModel() {

    public var bidirectionalString: MutableStateFlow<String> = MutableStateFlow<String>("SOME INPUT")
    public var bidirectionalBoolean: MutableStateFlow<Boolean> = MutableStateFlow<Boolean>(false)
    public var bidirectionalInt: MutableStateFlow<Int?> = MutableStateFlow<Int?>(42)
    public var bidirectionalLong: MutableStateFlow<Long> = MutableStateFlow<Long>(424242L)

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

#### Important: Some logs are added on DEBUG, there are removed when building on release 

```swift
@ktViewModelBinding(ofType: ExampleViewModel.self,
                    publishing:
        .init(\.stringData, String.self),
                    .init(\.intNullableData, Int?.self),
                    .init(\.randomValue, Double.self),
                    .init(\.entityData, MyData?.self),
                    .init(\.bidirectionalString, String.self, true),
                    .init(\.bidirectionalInt, Int?.self, true),
                    .init(\.bidirectionalBoolean, Bool.self, true),
                    .init(\.bidirectionalLong, Int64.self, true)
)
class MyMainScreenViewModel: ObservableObject {}
```
<details>
<summary>Generated content</summary>

### Important: The debug logs are removed when building on release 

```swift
class MyMainScreenViewModel : ObservableObject {
    private let viewModelStore = ViewModelStore()

    @Published private(set) var stringData: String

    @Published private(set) var intNullableData: Int?

    @Published private(set) var randomValue: Double

    @Published private(set) var entityData: MyData?

    @Published var bidirectionalString: String {
            didSet {
                instance.bidirectionalString.value = bidirectionalString
            }
        }

    @Published var bidirectionalInt: Int? {
            didSet {
                instance.bidirectionalInt.value = bidirectionalInt != nil ? KotlinInt(integerLiteral: bidirectionalInt!) : nil
            }
        }

    @Published var bidirectionalBoolean: Bool {
            didSet {
                instance.bidirectionalBoolean.value = KotlinBoolean(bool:  bidirectionalBoolean)
            }
        }

    @Published var bidirectionalLong: Int64 {
            didSet {
                instance.bidirectionalLong.value = KotlinLong(value: bidirectionalLong)
            }
        }

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
        self.bidirectionalString = viewModel.bidirectionalString.value
        print("INIT bidirectionalString : " + String(describing: viewModel.bidirectionalString.value))
        self.bidirectionalInt = viewModel.bidirectionalInt.value?.intValue
        print("INIT bidirectionalInt : " + String(describing: viewModel.bidirectionalInt.value))
        self.bidirectionalBoolean = viewModel.bidirectionalBoolean.value.boolValue
        print("INIT bidirectionalBoolean : " + String(describing: viewModel.bidirectionalBoolean.value))
        self.bidirectionalLong = viewModel.bidirectionalLong.value.int64Value
        print("INIT bidirectionalLong : " + String(describing: viewModel.bidirectionalLong.value))
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
                        print("UPDATING TO VIEW stringData : " + String(describing: value))
                        #endif
                        self?.stringData = value
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.intNullableData where self != nil {
                    if value?.intValue != self?.intNullableData {
                        #if DEBUG
                        print("UPDATING TO VIEW intNullableData : " + String(describing: value))
                        #endif
                        self?.intNullableData = value?.intValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.randomValue where self != nil {
                    if value.doubleValue != self?.randomValue {
                        #if DEBUG
                        print("UPDATING TO VIEW randomValue : " + String(describing: value))
                        #endif
                        self?.randomValue = value.doubleValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.entityData where self != nil {
                    if value != self?.entityData {
                        #if DEBUG
                        print("UPDATING TO VIEW entityData : " + String(describing: value))
                        #endif
                        self?.entityData = value
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.bidirectionalString where self != nil {
                    if value != self?.bidirectionalString {
                        #if DEBUG
                        print("UPDATING TO VIEW bidirectionalString : " + String(describing: value))
                        #endif
                        self?.bidirectionalString = value
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.bidirectionalInt where self != nil {
                    if value?.intValue != self?.bidirectionalInt {
                        #if DEBUG
                        print("UPDATING TO VIEW bidirectionalInt : " + String(describing: value))
                        #endif
                        self?.bidirectionalInt = value?.intValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.bidirectionalBoolean where self != nil {
                    if value.boolValue != self?.bidirectionalBoolean {
                        #if DEBUG
                        print("UPDATING TO VIEW bidirectionalBoolean : " + String(describing: value))
                        #endif
                        self?.bidirectionalBoolean = value.boolValue
                    }
                }
            }
            $0.addTask { @MainActor [weak self] in
                for await value in self!.instance.bidirectionalLong where self != nil {
                    if value.int64Value != self?.bidirectionalLong {
                        #if DEBUG
                        print("UPDATING TO VIEW bidirectionalLong : " + String(describing: value))
                        #endif
                        self?.bidirectionalLong = value.int64Value
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
    @StateObject var viewModel = MyMainScreenViewModel(ExampleViewModel())
    
    var body: some View {
        VStack {
            Text("STRING VALUE \(viewModel.stringData)")
            Text("NULL VALUE \(String(describing: viewModel.intNullableData))")
            Text("RANDOM VALUE \(viewModel.randomValue)")
            Text("BIDI STRING VALUE \(viewModel.bidirectionalString)")
            Text("BIDI BOOLEAN SHEET VALUE \(viewModel.bidirectionalBoolean)") // see app logs for update
            TextField("MY bidirectional String", text: $viewModel.bidirectionalString) // see app logs for update
            Button {
                viewModel.instance.randomizeValue()
            } label: {
                Text("randomizeValue")
            }
            Button("Show Sheet") {
                viewModel.bidirectionalBoolean.toggle()
            }
            .sheet(isPresented: $viewModel.bidirectionalBoolean) {
                SheetView()
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
