//
//  ColoringPageView.swift
//  TEST
//
//  Created by Daniel Youssef on 9/26/23.
//

import SwiftUI

struct ColoringPageView: View {
    // @Binding is used when variables need to be passed between 2 views
    @Environment(\.dismiss) var dismiss
    @Binding var selectedPicture: String
    var body: some View {
        VStack {
//            Text("Coloring Page")
//                .font(.largeTitle)
            ZStack {
                Canvas { ctx, size in
                    
                }
                //
                ToolsAndCanvasView(animal: self.selectedPicture)
                
            }
        }
        //.navigationTitle("Coloring Page")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement:.navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Label("Back", systemImage: "house.fill").foregroundColor(Color.black)
                        }
                    }
                }
    }
}


struct ColoringPageView_Previews: PreviewProvider {
    // When using @Binding, @State static must be used to show preview
    @State static var selectedPicture: String = ""
    static var previews: some View {
        ColoringPageView(selectedPicture: $selectedPicture)
    }
}
