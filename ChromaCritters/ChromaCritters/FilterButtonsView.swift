//
//  FilterButtonsView.swift
//  ChromaCritters
//
//  Created by Daniel Youssef on 9/28/23.
//
//
//import SwiftUI
//
//struct FilterButtonsView: View {
//    @State private var selectedAnimalArray: [String] = []
//    var animalPictures = AnimalImages.animalDictionary.values.flatMap{$0}
//    var animalsArray: [String] {
//        return Array(AnimalImages.animalDictionary.keys)
//    }
//
//    var body: some View {
//        ScrollView(.horizontal) {
//            HStack(spacing: 0) {
//                // Moves selected buttons to the front
//                ForEach(animalsArray.sorted { animal1, animal2 in
//                    let firstSelected = selectedAnimalArray.contains(animal1)
//                    let secondSelected = selectedAnimalArray.contains(animal2)
//
//                    // Goes back to sorted array if no animal was selected
//                    if firstSelected == secondSelected {
//                        return animal1 < animal2
//                    } else {
//                        return firstSelected
//                    }
//
//                }, id: \.self) { animal in
//                    Button {
//                        if selectedAnimalArray.contains(animal) {
//                            selectedAnimalArray.removeAll(where: { $0 == animal })
//                        } else {
//                            selectedAnimalArray.append(animal)
//                        }
//                    } label: {
//                        Image(systemName: selectedAnimalArray.contains(animal) ? "xmark" : "")
//                        Text("\(animal)")
//                    }
//                    .buttonStyle(.bordered)
//                    .buttonBorderShape(.capsule)
//                    .controlSize(.large)
//                    .tint(selectedAnimalArray.contains(animal) ? Color.red : Color.accentColor)
//                    .padding(.horizontal, 3)
//                }
//                .padding(.leading)
//            }
//        }
//        .scrollIndicators(.hidden)
//    }
//}
//
//struct FilterButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterButtonsView()
//    }
//}
import SwiftUI
struct FilterButtonsView: View {
    // Used in HomepageView
    @Binding var selectedAnimalFilters: [String]
    var animalsArray: [String] {
        return Array(AnimalImages.animalDictionary.keys)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                // Moves selected buttons to the front
                ForEach(animalsArray.sorted { animal1, animal2 in
                    let firstSelected = selectedAnimalFilters.contains(animal1)
                    let secondSelected = selectedAnimalFilters.contains(animal2)
                    
                    // Goes back to the sorted array if no animal was selected
                    if firstSelected == secondSelected {
                        return animal1 < animal2
                    } else {
                        return firstSelected
                    }
                }, id: \.self) { animal in
                    Button {
                        if selectedAnimalFilters.contains(animal) {
                            selectedAnimalFilters.removeAll(where: { $0 == animal })
                        } else {
                            selectedAnimalFilters.append(animal)
                        }
                    } label: {
                        Image(systemName: selectedAnimalFilters.contains(animal) ? "xmark" : "")
                        Text("\(animal)")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .tint(selectedAnimalFilters.contains(animal) ? Color.red : Color.accentColor)
                    .padding(.horizontal, 3)
                }
                .padding(.leading)
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct FilterButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonsView(selectedAnimalFilters: .constant([]))
    }
}
