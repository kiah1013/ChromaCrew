//
//  DisplayFinishedView.swift
//  ChromaCritters
//
//  Created by Lexi Lashbrook on 11/21/23.
//

import SwiftUI

struct DisplayFinishedView: View {
    // @Binding is used when variables need to be passed between 2 views
    @Environment(\.dismiss) var dismiss
    @Binding var displayThisPic: UIImage
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    
                    Image(uiImage: displayThisPic)
                        .resizable()
                        .scaledToFit()
                        .border(Color("borderColor"), width: 2)
                        .clipped() // Keeps pictures within the border
                        .cornerRadius(15)
                    
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement:.navigationBarLeading) {
                        Button{
                            dismiss()
                            
                        }label: {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color("titleColor"))
                                .font(.title)
                        }
                        
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
                    .accentColor(Color.black)
                    .background(colorScheme == .light
                                ?    LinearGradient(gradient: Gradient(colors:
                                                                        [Color(red: 254/255, green: 247/255, blue: 158/255),
                                                                         Color(red:169/255, green: 255/255, blue: 158/255),
                                                                         Color(red: 158/255, green: 249/255, blue: 252/255),
                                                                         Color(red: 159/255, green: 158/255, blue: 254/255),]),
                                                    startPoint: .topLeading, endPoint: .bottomTrailing)
                                
                                : LinearGradient(gradient: Gradient(colors:
                                                                        [Color(red: 0, green: 0, blue: 0.2),
                                                                         Color(red: 0.7, green: 0.25, blue: 0.9),
                                                                         Color(red: 0.5, green: 0.35, blue: 0.9),
                                                                         Color(red: 0.07, green: 0.2, blue: 0.3),
                                                                         Color(red: 0, green: 0, blue: 0.2)]),
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}

struct DisplayFinishedView_Previews: PreviewProvider {
    // When using @Binding, @State static must be used to show preview
    @State static var displayThisPic = UIImage()
    static var previews: some View {
        DisplayFinishedView(displayThisPic: $displayThisPic)
    }
}
