//
//  MagnifyView.swift
//  ChromaCritters
//
//  Created by Krisma Antonio on 10/3/23.
//

//
//  DELETE.swift
//  ChromaCritters
//
//  Created by Daniel Youssef on 10/2/23.
//

import SwiftUI

struct MagnifyView: View {
    @State  var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @Binding var selectedPicture: String
    let minScale: CGFloat = 1.0 // Adjust the minimum scale as needed
    let maxScale: CGFloat = 3.0 // Adjust the maximum scale as needed

    var body: some View {
        Image("CC_img01")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .frame(width: 400, height: 400)

            //.border(Color.black)
            .offset(offset)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = scale * value.magnitude
                        scale = min(max(newScale, minScale), maxScale)
                    }
                    .simultaneously(with: DragGesture().onChanged { value in
                        withAnimation(.spring()){
                            offset = value.translation
                        }
                            })
            )
    }
}

struct zoom_Previews: PreviewProvider {
    static var previews: some View {
        MagnifyView(selectedPicture: .constant(""))
    }
}
