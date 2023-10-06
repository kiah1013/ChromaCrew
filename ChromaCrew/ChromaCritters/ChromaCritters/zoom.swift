//
//  zoomies.swift
//  DrawingAppApp
//
//  Created by Lexi Lashbrook on 9/29/23.
//

import SwiftUI

struct zoom: View {
    
    @Binding var selectedPicture: String
    var body: some View {
        VStack{
            
            //Image(self.selectedPicture)
                //.frame(width:390, height: 390)
            //    .resizable().scaledToFit().border(.black, width: 5).padding(2)
            //    .frame(width: getRect().width - 30, height: 250)
            //    .cornerRadius(15)
            
            //ToolsAndCanvasView(animal: self.selectedPicture)
            //CanvasView(animal: self.selectedPicture)
            //   .addPinchToZoom()

        }
    }
    
    
}

struct zoomies_Previews: PreviewProvider {
    @State static var selectedPicture: String = ""
    static var previews: some View {
        zoom(selectedPicture: $selectedPicture)
    }
}
//add pinch to zoom custom modifier
//extension View{
//    func addPinchToZoom()->some View{
//        return PinchZoomContext{
//            self
//        }
//    }
//}
////Helper struct
//struct PinchZoomContext<Content: View>: View{
//    
//    var content: Content
//    init(@ViewBuilder content: @escaping  ()-> Content){
//        self.content = content()
//        
//    }
//    //Offset and scale data
//    @State var offset:CGPoint = .zero
//    @State var scale: CGFloat = 0
//    @State var scalePosition:  CGPoint = .zero
//    //private let minScale = 1.0
//    //private let maxScale = 5.0
//
//    
//    var body: some View{
//        content
//        //apply offset before scaling
//            .offset(x: offset.x, y: offset.y)
//        //UIKit gestures for simultaneously recognizing pinch and pan gestures
//            .overlay(
//                
//                GeometryReader{proxy in
//                    let size = proxy.size
//                    ZoomGesture(size: size, scale: $scale, offset: $offset, scalePosition:
//                    $scalePosition)
//                }
//                    
//            )
//        //Scaling content
//            .scaleEffect(1 + scale,anchor: .init(x: scalePosition.x, y: scalePosition.y))
//        
//        
//    }
//    
//    
//
//    
//}
//struct ZoomGesture: UIViewRepresentable{
//    func updateUIView(_ uiView: UIView, context: Context) {
//        
//    }
//    
//    var size: CGSize
//    @Binding var scale: CGFloat
//    @Binding var offset: CGPoint
//    @Binding var scalePosition: CGPoint
//    //connect coordinator
//    func makeCoordinator() -> Coordinator{
//        
//        return Coordinator(parent: self)
//    }
//    
//        func makeUIView(context: Context) -> UIView{
//            let view = UIView()
//            view.backgroundColor = .clear
//            
//            //add the gestures
//            let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
//            view.addGestureRecognizer(Pinchgesture)
//            
//            //add pan gesture
//            let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
//            
//            Pangesture.delegate = context.coordinator
//            
//            view.addGestureRecognizer(Pinchgesture)
//            view.addGestureRecognizer(Pangesture)
//            return view
//    }
//    
//    class Coordinator: NSObject, UIGestureRecognizerDelegate{
//        var parent: ZoomGesture
//        
//        init(parent: ZoomGesture) {
//            self.parent = parent
//        }
//        
//        // making pan recognize zoom sumltaneously
//        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//        shouldRecognizeSimultaneouslyWith otherGestureRecognizer:  UIGestureRecognizer) ->
//        Bool {
//            return true
//        }
//        
//        
//        @objc
//        func handlePan(sender: UIPanGestureRecognizer){
//            
//            //Not sure we need this
//            sender.maximumNumberOfTouches = 2
//            if (sender.state == .began || sender.state == .changed) && parent.scale > 0{
//                if let view = sender.view{
//                    
//                    //get translation
//                    let translation = sender.translation(in: view)
//                    parent.offset = translation
//                    
//                }
//            }
//            else{
//                
//                   // parent.offset = .zero
//                   // parent.scalePosition = .zero
//                
//                
//            }
//            
//        }
//        
//        @objc
//        func handlePinch(sender: UIPinchGestureRecognizer){
//            //calculate scale
//            if sender.state == .began || sender.state == .changed{
//                
//                parent.scale = sender.scale - 1
//                //get position where user pinched
//                let scalePoint = CGPoint(x: sender.location(in: sender.view).x / sender.view!.frame.size.width, y:
//                                            sender.location(in: sender.view).y / sender.view!.frame.size.height)
//                parent.scalePosition = (parent.scalePosition == .zero ? scalePoint : parent.scalePosition)
//            }
//            
//        }
//        
//    }
//    
//}
////get Screen Bounds
//extension View{
//    func getRect()->CGRect{
//        return UIScreen.main.bounds
//    }
//}
