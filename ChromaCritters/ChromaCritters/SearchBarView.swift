//
//  SearchBarView.swift
//  ChromaCritters
//
//  Created by Daniel Youssef on 10/13/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchedAnimal: String
    @Binding var selectedFilters: [String]
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("customBlack"))
            TextField("", text: $searchedAnimal, prompt: Text("Search animal...").foregroundColor(Color("customGray")))
                .foregroundColor(Color("customBlack"))
                .autocorrectionDisabled()
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.primary)
                        .opacity(searchedAnimal.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchedAnimal = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(radius: 10)
        }
        .padding()
        // Removes the selected filters if user searches
        .onChange(of: searchedAnimal) { newSearch, _ in
            if !newSearch.isEmpty {
                selectedFilters.removeAll()
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var searchedAnimal: String = ""
    
    static var previews: some View {
        SearchBarView(searchedAnimal: $searchedAnimal, selectedFilters: .constant([]))
    }
}
