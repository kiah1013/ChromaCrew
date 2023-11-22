//
//  SwiftUIView.swift
//  TEST
//
//  Created by Daniel Youssef on 9/26/23.
//
//

import SwiftUI
import Foundation
import AuthenticationServices
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct HomepageView: View {
    @State private var searchedAnimal = ""
    @State private var selectedPicture = ""
    @State private var dailySelected = ""
    @State private var selectedAnimalFilters: [String] = []
    @Environment(\.colorScheme) var colorScheme
    
    
    // Flatmap flattens an array of arrays into a single array, $0 means no transformations
    var picturesArray = AnimalImages.nonTransparentAnimalDictionary.values.flatMap { $0 }
    
    var body: some View {
        let columnLayout = Array(repeating: GridItem(), count: 2)
        
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Library")
                        .padding(.top)
                        .foregroundColor(Color("titleColor"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    NavigationLink(destination: UserProfileView()){
                        
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundColor(Color("titleColor"))
                        
                    }
                    .padding(.leading, -130)
                    .padding(.top, -60)
                    SearchBarView(searchedAnimal: $searchedAnimal, selectedFilters: $selectedAnimalFilters)
                }
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
                                             startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                
                Divider()
                ScrollView {
                    DailyImageView()
                    ScrollView {
                        
                        Spacer()
                        Spacer()
                        FilterButtonsView(selectedAnimalFilters: $selectedAnimalFilters)
                        LazyVGrid(columns: columnLayout) {
                            ForEach(filteredPicturesArray, id: \.self) { picture in
                                if searchedAnimal.isEmpty || picture.lowercased().contains(searchedAnimal.lowercased()) {
                                    VStack {
                                        Image(picture)
                                            .resizable()
                                            .scaledToFit()
                                            .border(Color("borderColor"), width: 2)
                                            .clipped() // Keeps pictures within the border
                                            .cornerRadius(15)
                                            .padding()
                                            .onTapGesture {
                                                selectedPicture = picture+"1" // Updated here
                                            }
                                    }
                                }
                            }
                            // Switches to ColoringPageView when picture is tapped
                            NavigationLink("", destination: ColoringPageView(selectedPicture: $selectedPicture), isActive: Binding(
                                get: { selectedPicture != "" },
                                set: { if !$0 { selectedPicture = "" } }
                            ))
                        }
                    }
                }.background(Color("customBackground"))
            }
        }
    }
    
    // Filters array based on the selected images
    var filteredPicturesArray: [String] {
        if selectedAnimalFilters.isEmpty {
            return picturesArray
        } else {
            return picturesArray.filter { animalImage in
                let animalCategory = AnimalImages.nonTransparentAnimalDictionary.first { _, images in
                    images.contains(animalImage)
                }?.key
                return selectedAnimalFilters.contains(animalCategory ?? "")
            }
        }
    }
    
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomepageView().preferredColorScheme(.light)
            HomepageView().preferredColorScheme(.dark)
        }
    }
}
