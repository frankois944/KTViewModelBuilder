//
//  SwiftUIView.swift
//  iosApp
//
//  Created by Francois Dabonot on 03/12/2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import KTViewModelBuilder
import shared

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

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}

struct ExampleScreen: View {
    
    // init the viewmodel, binding and lifecycle
    @StateObject var viewModel = MyMainScreenViewModel(.init())
    
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
        }
        .task {
            // start viewmodel lifecycle
            await viewModel.start()
        }
    }
}

#Preview {
    ExampleScreen()
}
