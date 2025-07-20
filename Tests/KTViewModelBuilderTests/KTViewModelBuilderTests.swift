import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(KTViewModelBuilderMacros)
import KTViewModelBuilderMacros

let testMacros: [String: Macro.Type] = [
    "ktViewModel": SharedViewModelMacro.self,
    "ktViewModelBinding": SharedViewModelBindingMacro.self
]
#endif

final class KTViewModelBuilderTests: XCTestCase {
    func testMacro() throws {
        #if canImport(KTViewModelBuilderMacros)
        assertMacroExpansion(
            """
            @ktViewModelBinding(ofType: MainScreenViewModel.self,
                                publishing:
                .init(\\.stringData, String.self),
                .init(\\.intNullableData, Int?.self),
                .init(\\.randomValue, Double.self),
                .init(\\.entityData, MyData?.self),
                .init(\\.bidirectionalString, String.self, true),
                .init(\\.bidirectionalInt, Int?.self, true),
                .init(\\.bidirectionalBoolean, Bool.self, true),
                .init(\\.bidirectionalLong, Int64.self, true),
                .init(\\.bidirectionalDouble, Double.self, true),
                .init(\\.bidirectionalFloat, Float.self, true),
                .init(\\.bidirectionalUnit, UInt.self, true)
            )
            class MainScreenVM: ObservableObject {}
            """,
            expandedSource: """
            class MainScreenVM: ObservableObject {

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

                @Published var bidirectionalDouble: Double {
                        didSet {
                            instance.bidirectionalDouble.value = KotlinDouble(double: bidirectionalDouble)
                        }
                    }

                @Published var bidirectionalFloat: Float {
                        didSet {
                            instance.bidirectionalFloat.value = KotlinFloat(float: bidirectionalFloat)
                        }
                    }

                @Published var bidirectionalUnit: UInt {
                        didSet {
                            instance.bidirectionalUnit.value = KotlinUInt(value: bidirectionalUnit)
                        }
                    }

                init(_ viewModel: MainScreenViewModel) {
                    self.viewModelStore.put(key: "MainScreenViewModelKey", viewModel: viewModel)
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
                    self.bidirectionalDouble = viewModel.bidirectionalDouble.value.doubleValue
                    print("INIT bidirectionalDouble : " + String(describing: viewModel.bidirectionalDouble.value))
                    self.bidirectionalFloat = viewModel.bidirectionalFloat.value.floatValue
                    print("INIT bidirectionalFloat : " + String(describing: viewModel.bidirectionalFloat.value))
                    self.bidirectionalUnit = viewModel.bidirectionalUnit.value.uintValue
                    print("INIT bidirectionalUnit : " + String(describing: viewModel.bidirectionalUnit.value))
                }

                var instance: MainScreenViewModel {
                    self.viewModelStore.get(key: "MainScreenViewModelKey") as! MainScreenViewModel
                }

                private var jobs = [Task<(), Never>]()

                @MainActor func start() async {
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.stringData where self != nil {
                            if value != self?.stringData {
                                #if DEBUG
                                print("UPDATING TO VIEW stringData : " + String(describing: value))
                                #endif
                                self?.stringData = value
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.intNullableData where self != nil {
                            if value?.intValue != self?.intNullableData {
                                #if DEBUG
                                print("UPDATING TO VIEW intNullableData : " + String(describing: value))
                                #endif
                                self?.intNullableData = value?.intValue
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.randomValue where self != nil {
                            if value.doubleValue != self?.randomValue {
                                #if DEBUG
                                print("UPDATING TO VIEW randomValue : " + String(describing: value))
                                #endif
                                self?.randomValue = value.doubleValue
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.entityData where self != nil {
                            if value != self?.entityData {
                                #if DEBUG
                                print("UPDATING TO VIEW entityData : " + String(describing: value))
                                #endif
                                self?.entityData = value
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalString where self != nil {
                            if value != self?.bidirectionalString {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalString : " + String(describing: value))
                                #endif
                                self?.bidirectionalString = value
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalInt where self != nil {
                            if value?.intValue != self?.bidirectionalInt {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalInt : " + String(describing: value))
                                #endif
                                self?.bidirectionalInt = value?.intValue
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalBoolean where self != nil {
                            if value.boolValue != self?.bidirectionalBoolean {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalBoolean : " + String(describing: value))
                                #endif
                                self?.bidirectionalBoolean = value.boolValue
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalLong where self != nil {
                            if value.int64Value != self?.bidirectionalLong {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalLong : " + String(describing: value))
                                #endif
                                self?.bidirectionalLong = value.int64Value
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalDouble where self != nil {
                            if value.doubleValue != self?.bidirectionalDouble {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalDouble : " + String(describing: value))
                                #endif
                                self?.bidirectionalDouble = value.doubleValue
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalFloat where self != nil {
                            if value.floatValue != self?.bidirectionalFloat {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalFloat : " + String(describing: value))
                                #endif
                                self?.bidirectionalFloat = value.floatValue
                            }
                        }
                        })
                    jobs.append(Task { [weak self] in
                        for await value in self!.instance.bidirectionalUnit where self != nil {
                            if value.uintValue != self?.bidirectionalUnit {
                                #if DEBUG
                                print("UPDATING TO VIEW bidirectionalUnit : " + String(describing: value))
                                #endif
                                self?.bidirectionalUnit = value.uintValue
                            }
                        }
                        })
                }

                deinit {
                    self.jobs.forEach {
                        $0.cancel()
                    }
                    self.jobs.removeAll()
                    self.viewModelStore.clear()
                    print("DEINIT \(self)")
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLegacyMacro() throws {
        #if canImport(KTViewModelBuilderMacros)
        assertMacroExpansion(
            """
            @ktViewModel(ofType: MainScreenViewModel.self,
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
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
