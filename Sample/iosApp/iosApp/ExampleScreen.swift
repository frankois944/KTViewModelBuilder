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

@sharedViewModel(ofType: ExampleViewModel.self,
                 publishing:
                    (\.stringData, String.self),
                 (\.intNullableData, Int?.self),
                 (\.randomValue, Double.self),
                 (\.entityData, MyData?.self)
)
class ExampleiOSViewModel : ObservableObject {}


struct ExampleScreen: View {
    
    // init the viewmodel, binding and lifecycle
    @StateObject var viewModel = ExampleiOSViewModel()
    
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
            // start viewmodel lifecycle
            await viewModel.start()
        }
    }
}

#Preview {
    ExampleScreen()
}
