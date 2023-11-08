//
//  UserProfileView.swift
//  ChromaCritters
//
//  Created by Lexi Lashbrook on 11/5/23.
//
import SwiftUI

struct UserProfileView: View {
    //modify the gridContent when adding pictures to this page
    @State private var IsGridEmpty = true
    @Environment(\.dismiss) var dismiss
    @State private var selectedPicture = ""
    
    // Flatmap flattens an array of arrays into a single array, $0 means no transformations
    var picturesArray = AnimalImages.animalDictionary.values.flatMap { $0 }
    
    var body: some View {
        let columnLayout = Array(repeating: GridItem(), count: 2)
        
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Profile")
                        .padding(.top)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 23))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, -375)
                    .padding(.top, -60)
                }
                .navigationBarBackButtonHidden(true)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 254/255, green: 247/255, blue: 158/255),
                                                                       Color(red:169/255, green: 255/255, blue: 158/255),
                                                                       Color(red: 158/255, green: 249/255, blue: 252/255),
                                                                       Color(red: 159/255, green: 158/255, blue: 254/255),
                                                                       Color(red: 255/255, green: 155/255, blue: 233/255),
                                                                       Color(red: 254/255, green: 195/255, blue: 155/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Divider()
                ScrollView {
                    Spacer()
                    if IsGridEmpty == true {
                        VStack {
                            Text("Your works in progress will appear here.")
                                .foregroundColor(.gray)
                                .padding(.top, 300)
                        }
                    }
                    else{
                        LazyVGrid(columns: columnLayout) {
                            VStack {
                                Image("dog1")
                                    .resizable()
                                    .scaledToFit()
                                    .border(Color.black)
                                    .clipped() // Keeps pictures within the border
                                    .padding()
                                    .onTapGesture {
                                        selectedPicture = "dog1"
                                     
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
        }
    }
    
    
    
    struct UserProfile_Previews: PreviewProvider {
        static var previews: some View {
            UserProfileView()
        }
    }

#Preview {
    UserProfileView()
}
