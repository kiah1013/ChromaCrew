//
//  SwiftUIView.swift
//  TEST
//
//  Created by Daniel Youssef on 9/26/23.
//
//

import SwiftUI

struct HomepageView: View {
    @State private var searchedAnimal = ""
    @State private var selectedPicture = ""
    @State private var selectedAnimalFilters: [String] = []
    
    // Flatmap flattens an array of arrays into a single array, $0 means no transformations
    var picturesArray = AnimalImages.animalDictionary.values.flatMap { $0 }
    
    var body: some View {
        let columnLayout = Array(repeating: GridItem(), count: 2)
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Library")
                        .padding(.top)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    NavigationLink(destination: UserProfileView()){
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundColor(.black)
                            
                    }
                    .padding(.leading, -130)
                    .padding(.top, -60)
                    SearchBarView(searchedAnimal: $searchedAnimal, selectedFilters: $selectedAnimalFilters)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 254/255, green: 247/255, blue: 158/255),
                                                                       Color(red:169/255, green: 255/255, blue: 158/255),
                                                                       Color(red: 158/255, green: 249/255, blue: 252/255),
                                                                       Color(red: 159/255, green: 158/255, blue: 254/255),
                                                                       Color(red: 255/255, green: 155/255, blue: 233/255),
                                                                       Color(red: 254/255, green: 195/255, blue: 155/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Divider()
                //DailyImageView()
                ScrollView {
                    DailyImageView()
                    Spacer()
                    Spacer()
                    //DailyImageView()
                    FilterButtonsView(selectedAnimalFilters: $selectedAnimalFilters)
                        LazyVGrid(columns: columnLayout) {
                            //DailyImageView()
                            ForEach(filteredPicturesArray, id: \.self) { picture in
                                if searchedAnimal.isEmpty || picture.lowercased().contains(searchedAnimal.lowercased()) {
                                    VStack {
                                        Image(picture)
                                            .resizable()
                                            .scaledToFit()
                                            .border(Color.black)
                                            .clipped() // Keeps pictures within the border
                                            .padding()
                                            .onTapGesture {
                                                selectedPicture = picture // Updated here
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
            }
        }
    }
    
    // Filters array based on the selected images
    var filteredPicturesArray: [String] {
        if selectedAnimalFilters.isEmpty {
            return picturesArray
        } else {
            return picturesArray.filter { animalImage in
                let animalCategory = AnimalImages.animalDictionary.first { _, images in
                    images.contains(animalImage)
                }?.key
                return selectedAnimalFilters.contains(animalCategory ?? "")
            }
        }
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}

