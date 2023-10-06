//
//  SwiftUIView.swift
//  TEST
//
//  Created by Daniel Youssef on 9/26/23.
//

import SwiftUI

struct HomepageView: View {
    var picturesArray = ["CC_img01", "CC_img02", "CC_img03", "CC_img04", "CC_img05"]
    
    @State private var selectedPicture = ""
    @State var pictureTapped = false
    
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
                    LazyVGrid(columns: columnLayout) {
                        ForEach(picturesArray, id: \.self) { picture in
                            VStack {
                                Image(picture)
                                    .resizable()
                                    .scaledToFit()
                                    .border(Color.black)
                                    .clipped() // Keeps pictures within the border
                                    .padding()
                                    .onTapGesture {
                                        pictureTapped.toggle()
                                        selectedPicture = picture
                                    }
                            }
                        }
                    
                            NavigationLink("", destination: ColoringPageView(selectedPicture: $selectedPicture), isActive: $pictureTapped)
                        
                    }
                }
            }
        }
    }
}


struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}

