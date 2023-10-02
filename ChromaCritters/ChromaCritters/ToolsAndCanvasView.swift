//
//  ToolsAndCanvasView.swift
//  Sprint1
//
//  Created by Krisma Antonio on 9/26/23.
//

import SwiftUI

struct ToolsAndCanvasView: View {
    
       // @Environment(\.scenePhase) var scenePhase
        @State var lines: [Line] = []
        @State private var selectedColor = Color.blue
        @State private var selectedLineWidth: CGFloat = 7
        @State private var drawingTool = DrawingTool.pen
        //@Binding var selectedPicture: String
    
        private let pencilCase = PencilCase()
        var animal: String
        var lineCap:CGLineCap = .round
    
        var body: some View {
            VStack {
                Spacer()
           
                //--------------------Canvas for drawing------------------------
                ZStack {
                    Canvas {ctx, size in
                        for line in lines {
                            // if picked tool is pencil, do this
                            if line.tool == .pencil {
                                connectPointsWithPencil(ctx: ctx, line: line)
                            // if picked tool is pen/paint brush, do this
                            } else {
                                var path = Path()
                                path.addLines(line.points)
                             
                                // style of the line strokes
                                ctx.stroke(path, with: .color(line.color),
                                           style: StrokeStyle(lineWidth: line.lineWidth, lineCap: lineCapIs(tool: line.tool), lineJoin: .round))
                            }
                        }
                    }
                    .frame(width:390, height: 390)
                    Image(animal).resizable().scaledToFit().border(.black, width: 5).padding(2)
                }
                    // .gesture() actually shows the lines on the canvas and lets you add multiple lines
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({value in
                                let position = value.location
                                
                                if value.translation == .zero {
                                    lines.append(Line(tool: drawingTool, points: [position], color: selectedColor, lineWidth: selectedLineWidth))
                                } else {
                                    guard let lastIdx = lines.indices.last else {
                                        return
                                    }
                                    
                                    lines[lastIdx].points.append(position)
                                }
                            })
                    )
                    .offset(y: 30)
                    //.addPinchToZoom()
                    Spacer()
                    //zoom(selectedPicture: $selectedPicture)
                
                // -----------------bottom tool display--------------------
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .frame(width: 395, height: 100)
                        .foregroundColor(.gray).opacity(0.3)
                    VStack {
                        HStack{
                            Spacer()

                            toolSymbol(tool: .pen, imageName: "paintbrush.pointed.fill")
                            toolSymbol(tool: .pencil, imageName: "pencil")
                            toolSymbol(tool: .marker, imageName: "paintbrush.fill")
                            
                            ColorPicker("Color", selection: $selectedColor).padding().font(.largeTitle).labelsHidden()
                            Spacer()
                            undoButton()
                            redoButton()
                            clearButton()
                            Spacer()
                        
                        }
                        Slider(value: $selectedLineWidth, in: 1...20).frame(width:200).accentColor(selectedColor)
                    
                    }
                }
                    
            }
        }
    
        
    // -----------------------pencilLine effect functions-----------------
        private func pencilLine(
           ctx: GraphicsContext,
           pointA: CGPoint,
           pointB: CGPoint,
           color: Color,
           lineWidth: CGFloat
        ) {
           // Determine the length of the line
           var x = pointA.x
           var y = pointA.y
           let dx = pointB.x - x
           let dy = pointB.y - y
           let len = ((dx * dx) + (dy * dy)).squareRoot()

           // Determine the number of steps and the step sizes,
           // aiming for approx. 1 step per pixel of length
           let nSteps = max(1, Int(len + 0.5))
           let stepX = dx / CGFloat(nSteps)
           let stepY = dy / CGFloat(nSteps)

           // Draw the points of the line
           for _ in 0..<nSteps {
               let point = CGPoint(x: x, y: y)
               let pencilTip = pencilCase.pencilTip(
                   color: color,
                   lineWidth: lineWidth,
                   point: point
               )
               ctx.draw(pencilTip, at: point)
               x += stepX
               y += stepY
           }
        }

       private func connectPointsWithPencil(ctx: GraphicsContext, line: Line) {
           var lastPoint: CGPoint?
           for point in line.points {
               if let lastPoint {
                   pencilLine(
                       ctx: ctx,
                       pointA: lastPoint,
                       pointB: point,
                       color: line.color,
                       lineWidth: line.lineWidth
                   )
               }
               lastPoint = point
           }
       }
    
    // ---------------------------buttons----------------------------------
        func clearButton() -> some View {
            Button {
                lines = []
                //_ = lines.popLast()
            } label: {
                Image(systemName: "clear.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    
        func undoButton() -> some View {
            Button {
                _ = lines.popLast()
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    
        func redoButton() -> some View {
            Button {
                
            } label: {
                Image(systemName: "arrow.uturn.forward.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        
        // displaying tool symbol
        private func toolSymbol(tool: DrawingTool, imageName: String) -> some View {
           Button { drawingTool = tool } label: {
               Image(systemName: imageName)
                   .font(.title)
                   .foregroundColor(drawingTool == tool ? selectedColor : .gray)
               }
       }

        // --------------------determining line cap style------------------------
       func lineCapIs(tool: DrawingTool) -> CGLineCap {
           tool == .marker ? .square : .round
       }
}

#Preview {
    //@State var selectedPicture: String = ""
    ToolsAndCanvasView(animal: "CC_img01")
}

//----------------------------------------------------------------------------------//
//----------------------------LEXI'S ZOOM FUNCTION----------------------------------//
//----------------------------------------------------------------------------------//

//add pinch to zoom custom modifier
extension View{
    func addPinchToZoom()->some View{
        return PinchZoomContext{
            self
        }
    }
}
//Helper struct
struct PinchZoomContext<Content: View>: View{
    
    var content: Content
    init(@ViewBuilder content: @escaping  ()-> Content){
        self.content = content()
        
    }
    //Offset and scale data
    @State var offset:CGPoint = .zero
    @State var scale: CGFloat = 0
    @State var scalePosition:  CGPoint = .zero
    //private let minScale = 1.0
    //private let maxScale = 5.0

    
    var body: some View{
        content
        //apply offset before scaling
            .offset(x: offset.x, y: offset.y)
        //UIKit gestures for simultaneously recognizing pinch and pan gestures
            .overlay(
                
                GeometryReader{proxy in
                    let size = proxy.size
                    ZoomGesture(size: size, scale: $scale, offset: $offset, scalePosition:
                    $scalePosition)
                }
                    
            )
        //Scaling content
            .scaleEffect(1 + scale,anchor: .init(x: scalePosition.x, y: scalePosition.y))
    }
}

struct ZoomGesture: UIViewRepresentable{
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    var size: CGSize
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    @Binding var scalePosition: CGPoint
    //connect coordinator
    func makeCoordinator() -> Coordinator{
        
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView{
            let view = UIView()
            view.backgroundColor = .clear
            
            //add the gestures
            let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
            view.addGestureRecognizer(Pinchgesture)
            
            //add pan gesture
            let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
            
            Pangesture.delegate = context.coordinator
            
            view.addGestureRecognizer(Pinchgesture)
            view.addGestureRecognizer(Pangesture)
            return view
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate{
        var parent: ZoomGesture
        
        init(parent: ZoomGesture) {
            self.parent = parent
        }
        
        // making pan recognize zoom sumltaneously
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer:  UIGestureRecognizer) ->
        Bool {
            return true
        }
        
        
        @objc
        func handlePan(sender: UIPanGestureRecognizer){
            
            //Not sure we need this
            sender.maximumNumberOfTouches = 2
            if (sender.state == .began || sender.state == .changed) && parent.scale > 0{
                if let view = sender.view{
                    
                    //get translation
                    let translation = sender.translation(in: view)
                    parent.offset = translation
                    
                }
            }
            else{
                   // parent.offset = .zero
                   // parent.scalePosition = .zero
            }
            
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer){
            //calculate scale
            if sender.state == .began || sender.state == .changed{
                
                parent.scale = sender.scale - 1
                //get position where user pinched
                let scalePoint = CGPoint(x: sender.location(in: sender.view).x / sender.view!.frame.size.width, y:
                                            sender.location(in: sender.view).y / sender.view!.frame.size.height)
                parent.scalePosition = (parent.scalePosition == .zero ? scalePoint : parent.scalePosition)
            }
            
        }
        
    }
    
}
