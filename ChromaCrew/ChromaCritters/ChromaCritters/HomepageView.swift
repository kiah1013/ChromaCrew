//
//  SwiftUIView.swift
//  TEST
//
//  Created by Daniel Youssef on 9/26/23.
//
//

import SwiftUI

struct HomepageView: View {
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
                }
                
                Divider()
                
                ScrollView {
                    Spacer()
                    Spacer()
                    FilterButtonsView(selectedAnimalFilters: $selectedAnimalFilters) // Step 2
                    LazyVGrid(columns: columnLayout) {
                        ForEach(filteredPicturesArray, id: \.self) { picture in // Step 4
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
