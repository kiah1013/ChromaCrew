//
//  DailyImageView.swift
//  ChromaCritters
//
//  Created by Lexi Lashbrook on 11/13/23.
//

import SwiftUI

struct DailyImageView: View {
    @State private var selectedPicture = ""
    var picturesArray = AnimalImages.animalDictionary.values.flatMap { $0 }
    //let colLayout = Array(repeating: GridItem(), count: 1)
    var body: some View {
        let pic = picturesArray.randomElement()!
        
        NavigationStack {
        Text("Daily recommended image:")
            .font(.headline)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        
        Image("dog1")
            .resizable()
            .scaledToFit()
            .border(Color.black)
            .clipped() // Keeps pictures within the border
            .padding()
            .onTapGesture {
                selectedPicture = "dog1" // Updated here
            }
        NavigationLink("", destination: ColoringPageView(selectedPicture: $selectedPicture), isActive: Binding(
            get: { selectedPicture != "" },
            set: { if !$0 { selectedPicture = "" } }
        ))
        
        
    }
        .onTapGesture {
            
        }
            
            //NavigationStack {
            //   HStack{
            //                     Text("Featured image:")
            //                         .font(.headline)
            //                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            //                  Image(pic)
            //                    .resizable()
            //                  .scaledToFit()
            //                .border(Color.black)
            //              .clipped() // Keeps pictures within the border
            //            .padding()
            //          .onTapGesture {
            //            selectedPicture = pic // Updated here
            //      }
            
                  NavigationLink("", destination: ColoringPageView(selectedPicture: $selectedPicture), isActive: Binding(
                       get: { selectedPicture != "" },
                     set: { if !$0 { selectedPicture = "" } }
               ))
            
            //}.contentShape(Rectangle())
            //}
            
            
        }
    }


#Preview {
    DailyImageView()
}
