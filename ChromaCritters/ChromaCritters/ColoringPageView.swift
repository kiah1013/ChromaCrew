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
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack {
            ZStack {
                ToolsAndCanvasView(animal: self.selectedPicture, savingDocument: SavingDocument(animalPictureName: self.selectedPicture, userId: getUserId()))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement:.navigationBarLeading) {
                Button{
                    dismiss()
                    
                }label: {
                    Image(systemName: "house.fill")
                        .foregroundColor(Color("titleColor"))
                        .font(.title)
                }
                    }
                }
    }
    func getUserId() -> String {
        var userId: String
        
        if userAuth.isLogged {
            userId = "\(userAuth.userId!)"
        } else {
            userId = "0"
        }
        
        return userId
    }
}


struct ColoringPageView_Previews: PreviewProvider {
    // When using @Binding, @State static must be used to show preview
    @State static var selectedPicture: String = ""
    static var previews: some View {
        ColoringPageView(selectedPicture: $selectedPicture)
    }
}
