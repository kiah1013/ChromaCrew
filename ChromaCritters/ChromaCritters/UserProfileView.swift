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
import FirebaseAuth

struct UserProfileView: View {
    //modify the gridContent when adding pictures to this page
  //  @State private var IsGridEmpty = false
    @Environment(\.dismiss) var dismiss
    @State private var selectedPicture = ""
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var retrievedImages = [UIImage]()
    @State private var showingSignOutError = false
    @State private var signOutError: Error?
    @EnvironmentObject var userAuth: UserAuth
    @State var username: String = ""
    
    // Flatmap flattens an array of arrays into a single array, $0 means no transformations
    var picturesArray = AnimalImages.animalDictionary.values.flatMap { $0 }
    
    var body: some View {
        let columnLayout = Array(repeating: GridItem(), count: 2)
        
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
//                    if let user = userAuth.currentUser {
//                        Text("\(user.username)")
//                    }
                    Text("\(displayName())")
                        Text("Profile")
                            .foregroundColor(Color("titleColor"))
                            .padding(.top)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                    
                    Spacer()
                    Button(action: {
                        dismiss()
                    })  {
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
                Button("Sign Out") {
                    signOut()
                }
                .font(.headline)
                .foregroundColor(.red)
                .padding()
                .alert("Sign Out Error", isPresented: $showingSignOutError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(signOutError?.localizedDescription ?? "Unknown error")
                }
                .navigationBarBackButtonHidden(true)
                
                
                Divider()
                ScrollView {
                    Spacer()
//                    if IsGridEmpty == true {
//                        VStack {
//                            Text("Your works in progress will appear here.")
//                                .foregroundColor(.gray)
//                                .padding(.top, 300)
//                        }
//                    }
//                    else{
                        LazyVGrid(columns: columnLayout) {
                            ForEach(retrievedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .border(Color("borderColor"))
                                    .clipped() // Keeps pictures within the border
                                    .cornerRadius(15)
                                    .padding()
                            }
                        }
                    }
            //    }
                .onAppear {
                    retrievePhotos()
                }
            }
        }
    }
    func retrievePhotos() {
        let db = Firestore.firestore()
        // Crashes app when using Guest Mode
        guard let userId = userAuth.userId else {
            print("User ID is nil.")
            return
        }
        
        db.collection("coloredPagesDB").whereField("url", isGreaterThanOrEqualTo: "usersStorage/\(userId)/")
            .whereField("url", isLessThan: "usersStorage/\(userId)/z")
            .getDocuments { snapshot, error in
                if error == nil && snapshot != nil {
                    var paths = [String]()
                    
                    for doc in snapshot!.documents {
                        paths.append(doc["url"] as! String)
                    }
                    
                    for path in paths {
                        let storageRef = Storage.storage().reference()
                        let fileRef = storageRef.child(path)
                        
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { [self] data, error in
                            if error == nil, let data = data {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.retrievedImages.append(image)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userAuth.isLogged = false
                self.userAuth.isGuest = false
                self.userAuth.userId = nil
        //        self.userAuth.currentUser = nil
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
//    func fetchUser() {
//      //  var username: String = ""
//        
//        if userAuth.isLogged {
//            let userUID = userAuth.userId
//            Firestore.firestore().collection("users").document(userUID!).getDocument { snapshot, error in
//                if error != nil {
//                    // ERROR
//                    print("Error getting username")
//                }
//                else {
//                    self.username = snapshot!.get("username") as! String
//                    //print(name ?? "")
//                }
//                
//            }
//        } else {
//            print("User not logged in, cannot fetch user's name")
//        }
//    }
    
    func displayName() -> String {
        userAuth.fetchUser()
        let username = userAuth.username
        
        return username
    }
}

    

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView().environmentObject(UserAuth())
    }
}

#Preview {
    UserProfileView()
}
