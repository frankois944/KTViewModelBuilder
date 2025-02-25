import SwiftUI

// The Swift Programming Language
// https://docs.swift.org/swift-book


public struct Property<T> {
    let key: PartialKeyPath<T>
    let type: Any
    let bidirectional: Bool
    
    public init(_ key: PartialKeyPath<T>, _ type: Any.Type, _ bidirectional: Bool = false) {
        self.key = key
        self.type = type
        self.bidirectional = bidirectional
    }
}

@attached(member, names: arbitrary)
public macro ktViewModelBinding<T>(ofType: T.Type, publishing: Property<T>...) = #externalMacro(module: "KTViewModelBuilderMacros", type: "SharedViewModelBindingMacro")

@available(*, deprecated, message: "Use: ktViewModelBinding<T>(ofType: T.Type, publishing: Property<T>...)")
@attached(member, names: arbitrary)
public macro ktViewModel<T>(ofType: T.Type, publishing: (property: PartialKeyPath<T>, type: Any.Type)...) = #externalMacro(module: "KTViewModelBuilderMacros", type: "SharedViewModelMacro")


