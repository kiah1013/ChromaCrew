//
//  UserProfileView.swift
//  ChromaCritters
//
//  Created by Lexi Lashbrook on 11/5/23.
//
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct UserProfileView: View {
    //modify the gridContent when adding pictures to this page
    @State private var IsGridEmpty = false
    @Environment(\.dismiss) var dismiss
    @State private var selectedPicture = ""
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var retrievedImages = [UIImage]()
    @EnvironmentObject var userAuth: UserAuth
    
    // Flatmap flattens an array of arrays into a single array, $0 means no transformations
    var picturesArray = AnimalImages.animalDictionary.values.flatMap { $0 }
    
    var body: some View {
        let columnLayout = Array(repeating: GridItem(), count: 2)
            
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Profile")
                        .foregroundColor(Color("titleColor"))
                        .padding(.top)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                     
                    Spacer()
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color("titleColor"))
                    }
                    .padding(.leading, -375)
                    .padding(.top, -60)
                }
                .navigationBarBackButtonHidden(true)
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
                            ForEach(retrievedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .border(Color.black)
                                    .clipped() // Keeps pictures within the border
                                    .cornerRadius(15)
                                    .padding()
                            }
                        }
                    }
                }
                .onAppear {
                    retrievePhotos()
                }
            }
        }
    }
    func retrievePhotos() {
        let db = Firestore.firestore()
        // Crashes app when using Guest Mode
        let userId = userAuth.userId!
        
            db.collection("coloredPagesDB").whereField("url", isGreaterThanOrEqualTo: "usersStorage/\(userId)/").getDocuments { snapshot, error in
                if error == nil && snapshot != nil {
                    var paths = [String]()
                    
                    for doc in snapshot!.documents {
                        paths.append(doc["url"] as! String)
                    }
                    
                    for path in paths {
                        let storageRef = Storage.storage().reference()
                        let fileRef = storageRef.child(path)
                        
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            if error == nil && data != nil {
                                if let image = UIImage(data: data!) {
                                    DispatchQueue.main.async {
                                        retrievedImages.append(image)
                                    }
                                }
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
