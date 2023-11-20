//
//  ToolsAndCanvasView.swift
//  Sprint1
//
//  Created by Krisma Antonio on 9/26/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ToolsAndCanvasView: View {
        // variables for zooming in/out
        @State  var offset: CGSize = CGSize(width: 0, height: -60)
        @State private var scale: CGFloat = 1.0
        let minScale: CGFloat = 1.0 // Adjust the minimum scale as needed
        let maxScale: CGFloat = 3.0 // Adjust the maximum scale as needed
        @State var isPanning: Bool = false
        
        @Environment(\.colorScheme) var colorScheme
        @EnvironmentObject var userAuth: UserAuth
        var snapshotImage: UIImage? {
           let renderer = ImageRenderer(content: canvasForDrawing.frame(width:390, height: 390))
           let image = renderer.uiImage

           return image
       }
        // variables for drawing lines
        //@State var lines: [Line] = []
        @Environment(\.scenePhase) var scenePhase
        var animal: String
        @StateObject var savingDocument = SavingDocument(animalPictureName: "dog1", userId: "0")
        @State private var deletedLines = [Line]()
        @State private var selectedColor = Color.orange
        @State private var selectedLineWidth: CGFloat = 7
        @State private var drawingTool = DrawingTool.pen
        @State private var showConfirmation: Bool = false
        @State private var showAlert = false
        private let pencilCase = PencilCase()
        private let paintBrushCase = PaintbrushCase()
        var lineCap: CGLineCap = .round
        
        let green = Color(red: 0, green: 1, blue: 0)
        let blue = Color(red: 0, green: 0.4, blue: 1)
        let purple = Color(red: 0.5, green: 0, blue: 0.8)
        let red = Color(red: 1, green: 0, blue: 0.1)
        let orange = Color(red: 1, green: 0.5, blue: 0)
        let yellow = Color(red: 1, green: 1, blue: 0)
        let black = Color(red: 0.1, green: 0, blue: 0)

        var canvasForDrawing: some View {
            ZStack {
                Canvas {ctx, size in
                    for line in savingDocument.lines {
                        if line.tool == .pencil {
                            connectPointsWithPencil(ctx: ctx, line: line)
                        } else if line.tool == .paintbrush{
                            connectPointsWithPaintBrush(ctx: ctx, line: line)
                        } else if line.tool == .pen {
                            var path = Path()
                            path.addLines(line.points)
                            
                            ctx.stroke(path, with: .color(line.color),
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: lineCapIs(tool: line.tool), lineJoin: .round))
                        } else if line.tool == .eraser{
                            var path = Path()
                            path.addLines(line.points)
                            ctx.stroke(path, with: .color(.white),style: StrokeStyle(lineWidth: line.lineWidth, lineCap: lineCapIs(tool: line.tool), lineJoin: .round))
                        }
                    }
                        
                    } .frame(width:385, height: 385)
                    Image(animal).resizable().scaledToFit().border(Color("borderColor"), width: 5)
                }
            }
        
    
        var body: some View {
            VStack {
                Spacer()
                    canvasForDrawing.background(Color("customWhite"))
                    .gesture(
                        // shows the lines on the canvas and lets you add multiple lines
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({value in
                                if isPanning == false {
                                    let position = value.location
                                    
                                    if value.translation == .zero {
                                        savingDocument.lines.append(Line(tool: drawingTool, points: [position], color: selectedColor, lineWidth: selectedLineWidth))
                                    } else {
                                        guard let lastIdx = savingDocument.lines.indices.last else {
                                            return
                                        }
                                        
                                        savingDocument.lines[lastIdx].points.append(position)
                                    }
                                }
                            }).onEnded({value in
                                // if lines has something
                                if let last = savingDocument.lines.last?.points, last.isEmpty {
                                    savingDocument.lines.removeLast()
                                }
                            })
                        
                    )
                    // for moving the canvas
                    .offset(offset)
                    .simultaneousGesture(DragGesture().onChanged { value in
                        withAnimation(.spring()){
                                    if isPanning == true {
                                        offset = value.translation
                                    }
                                }
                    })
                    // for zooming the canvas
                    .scaleEffect(scale)
                    .gesture( MagnificationGesture()
                        .onChanged { value in
                            let newScale = scale * value.magnitude
                            scale = min(max(newScale, minScale), maxScale)
                        }
                    )
                    // for saving everytime a line is added
//                    .onChange(of: scenePhase) { oldChange, newValue in
//                        if newValue == .background {
//                            savingDocument.save()
//                        }
//                    }
                    
                // -----------------top/bottom tool display--------------------
                ZStack {
                    Rectangle().fill(colorScheme == .light
                     ?  LinearGradient(gradient: Gradient(colors:
                        [Color(red: 254/255, green: 247/255, blue: 158/255),
                        Color(red: 169/255, green: 255/255, blue: 158/255),
                        Color(red: 158/255, green: 249/255, blue: 252/255),
                        Color(red: 159/255, green: 158/255, blue: 254/255),
                        Color(red: 255/255, green: 155/255, blue: 233/255),
                        Color(red: 254/255, green: 195/255, blue:155/255)]),
                        startPoint: .topLeading, endPoint: .bottomTrailing)
                     : LinearGradient(gradient: Gradient(colors:
                        [Color(red: 0, green: 0, blue: 0.3),
                        Color(red: 0.67, green: 0.25, blue: 0.9),
                        Color(red: 0.5, green: 0.35, blue: 0.9),
                        Color(red: 0.07, green: 0.2, blue: 0.3),
                        Color(red: 0, green: 0, blue: 0.2)]),
                        startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                        .ignoresSafeArea().offset(y:-700)
                        .frame(width: 395, height: 132)
                        .foregroundColor(Color(hue: 0.0, saturation: 0.0, brightness: 0.75))
                    
                    // bottom tools display
                    Rectangle().fill(colorScheme == .light
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
                        .ignoresSafeArea()
                        .frame(width: 395, height: 135)
                        .foregroundColor(Color(hue: 0.0, saturation: 0.0, brightness: 0.75))
                    VStack {
                        HStack{
                            undoButton().offset(x:5)
                            redoButton().offset(x:5)
                            
                            Spacer()

                            toolSymbol(tool: .pen, imageName: "paintbrush.pointed.fill")
                            toolSymbol(tool: .pencil, imageName: "pencil")
                            toolSymbol(tool: .paintbrush, imageName: "paintbrush.fill")
                            // eraser tool
                            Button { drawingTool = .eraser } label: {
                                Image(systemName: "eraser.fill")
                                    .font(.title)
                                    .foregroundColor(drawingTool == .eraser ? .white : Color("toolsColor"))
                            }
                            // saving image to photos
                            .toolbar{
                                Button {
                                    let renderer = ImageRenderer(content: canvasForDrawing.frame(width:390, height: 390))
                                    if let image = renderer.uiImage {
                                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                    }
                                } label: {
                                    Image(systemName: "square.and.arrow.down.fill")
                                        .foregroundColor(Color("titleColor"))
                                        .font(.title)
                                }
                            }
                            .toolbar {
                                Button {
                                    uploadColoredPageToFirestore()
                                    showAlert = true
                                } label: {
                                    Text("Upload").foregroundColor(Color("titleColor"))
                                }.alert(isPresented: $showAlert) {
                                    Alert (
                                        title: Text("Upload Successful"),
                                        message: Text("Your image has been saved to your profile."))
                                }
                            }
                            
                            Spacer()
                            
                            clearButton().padding(5)
                        
                        }
                        HStack {
                            ForEach([green, blue, purple, red, orange, yellow, black], id: \.self) { color in
                                    colorButton(color:color)
                                }
                            ColorPicker("Color", selection: $selectedColor).padding(5).font(.largeTitle).labelsHidden()
                        }
                        HStack {
                            Slider(value: $selectedLineWidth, in: 1...20).frame(width:200).accentColor(selectedColor)
                            Button(action: {self.isPanning.toggle()}) {
                                if isPanning == true {
                                    Image(systemName: "dot.arrowtriangles.up.right.down.left.circle").font(.title)
                                } else {
                                    Image(systemName: "dot.arrowtriangles.up.right.down.left.circle").foregroundColor(Color("toolsColor")).font(.title)
                                }
                                }
                            }
                        }
                    }
                }
            }
            
        
    
    
    // ---------------------------buttons----------------------------------
        func uploadColoredPageToFirestore() {
            if userAuth.isLogged {
                guard snapshotImage != nil else {
                    return
                }

                // Create storage reference
                let storageRef = Storage.storage().reference()
                // Turn image into data
                let imageData = snapshotImage!.jpegData(compressionQuality: 0.8)

                guard imageData != nil else {
                    return
                }
                // Specify the file path and name
                let filePath = "coloredPagesStorage/\(UUID().uuidString).jpg"
                let fileRef = storageRef.child("usersStorage").child(userAuth.userId!).child(filePath)

                let uploadTask = fileRef.putData(imageData!, metadata: nil) {
                    metadata, error in

                    if error == nil && metadata != nil {
                        // get the filePath from storage and store into database
                        let db = Firestore.firestore()
                        // the content of url is the final url from the cloud firestore database
                        let dbFilePath = "usersStorage/\(userAuth.userId!)/"+filePath
                        db.collection("coloredPagesDB").document().setData(["url":dbFilePath])
                    }
                }
            } else {
                print("Not logged in, cannot upload colored page into database")
            }
        }
    
        func clearButton() -> some View {
            Button {
                showConfirmation = true
            } label: {
                Image(systemName: "pencil.tip.crop.circle.badge.minus")
                    .font(.title)
                    .foregroundColor(Color("buttonsColor"))
            }.confirmationDialog(Text("Are you sure you want to delete your progress?"), isPresented: $showConfirmation) {
                Button("Delete", role: .destructive) {
                    savingDocument.lines = [Line]()
                    deletedLines = [Line]()
                }
            }
        }
    
        func undoButton() -> some View {
            Button {
                // store last lines removed
                let last = savingDocument.lines.removeLast()
                deletedLines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(.title)
                    .foregroundColor(Color("buttonsColor"))
            }.disabled(savingDocument.lines.count == 0)
        }
    
        func redoButton() -> some View {
            Button {
                // append the deleted lines
                let last = deletedLines.removeLast()
                savingDocument.lines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.forward.circle")
                    .font(.title)
                    .foregroundColor(Color("buttonsColor"))
            }.disabled(deletedLines.count == 0)
        }
    
        func colorButton(color: Color) -> some View {
             Button {
                 selectedColor = color
             } label: {
                 Image(systemName: "circle.fill")
                     .font(.title)
                     .foregroundColor(color)
             }
         }
    
        private func toolSymbol(tool: DrawingTool, imageName: String) -> some View {
           Button { drawingTool = tool } label: {
               Image(systemName: imageName)
                   .font(.title)
                   .foregroundColor(drawingTool == tool ? selectedColor : Color("toolsColor"))
               }
       }

       func lineCapIs(tool: DrawingTool) -> CGLineCap {
           tool == .paintbrush ? .square : .round
       }
    
        // -----------------------paintbrush effect functions-----------------
        private func paintBrushLine(
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
               let pencilTip = paintBrushCase.paintBrushTip(
                   color: color,
                   lineWidth: lineWidth,
                   point: point
               )
               ctx.draw(pencilTip, at: point)
               x += stepX
               y += stepY
           }
        }

       private func connectPointsWithPaintBrush(ctx: GraphicsContext, line: Line) {
           var lastPoint: CGPoint?
           for point in line.points {
               if let lastPoint {
                   paintBrushLine(
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
    
        // -----------------------pencil effect functions-----------------
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
}



//#Preview {
//    Group {
//        ToolsAndCanvasView(animal: "dog1")
//    }
//}

struct ToolsAndCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToolsAndCanvasView(animal: "dog1").preferredColorScheme(.light)
            ToolsAndCanvasView(animal: "dog1").preferredColorScheme(.dark)
        }
    }
}
