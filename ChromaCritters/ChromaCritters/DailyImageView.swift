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
    let colLayout = Array(repeating: GridItem(), count: 1)
    var body: some View {
        LazyVGrid(columns: colLayout, content: {
            let pic = picturesArray.randomElement()!
                   
                       VStack{
                           Text("Featured image:")
                               .font(.headline)
                               .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                           
                           Image(pic)
                               .resizable()
                               .scaledToFit()
                               .border(Color.black)
                               .clipped() // Keeps pictures within the border
                               .padding()
                               
                       }
            
        })
    }
}

#Preview {
    DailyImageView()
}
