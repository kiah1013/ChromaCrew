//
//  DailyImageView.swift
//  ChromaCritters
//
//  Created by Lexi Lashbrook on 11/13/23.
//

import SwiftUI
import Foundation

struct DailyImageView: View {
    @State private var selectedPicture = ""
    @State private var dailySelected = ""
    @State var picture = ""
     //var picture = ""

    //var picturesArray = AnimalImages.animalDictionary.values.flatMap { $0 }
    var randomArray = AnimalImages.nonTransparentAnimalDictionary.values.flatMap { $0 }
    //let colLayout = Array(repeating: GridItem(), count: 1)
    var body: some View {
        NavigationStack {
            Text("Daily recommended image:")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            let i = getImageName()
            let picture = testImage()
            Image(i)
                .resizable()
                .scaledToFit()
                .border(Color("borderColor"), width: 2)
                .clipped() // Keeps pictures within the border
                .cornerRadius(15)
                .padding()
                .onTapGesture {
                    dailySelected = picture // Updated here
                    
                }
            NavigationLink("", destination: ColoringPageView(selectedPicture: $dailySelected), isActive: Binding(
                get: { dailySelected != "" },
                set: { if !$0 { dailySelected = "" } }
            ))
        }
            
            
        }
    private func getImageName() -> String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date())!
        print(day)
        let imagesCount = 5
        let imageName = day % imagesCount + 1
        print(imageName)
        return String(imageName)
    }
    private func testImage()->String
    {
        var pic = ""
        let i = getImageName()
        if i == "1"{
            pic = "dog1"
        }
        if i == "2"{
            pic = "cat1"
        }
        if i == "3"{
            pic = "bear1"
        }
        if i == "4"{
            pic = "duck1"
        }
        if i == "5"{
            pic = "bunny1"
        }
        return(pic)
    }
    
    }


#Preview {
    DailyImageView()
}
