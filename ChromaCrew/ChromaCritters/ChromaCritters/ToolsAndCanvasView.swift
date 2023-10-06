//
//  ToolsAndCanvasView.swift
//  Sprint1
//
//  Created by Krisma Antonio on 9/26/23.
//

import SwiftUI

struct ToolsAndCanvasView: View {
        // variables for zooming in/out
        @State  var offset: CGSize = .zero
        @State private var scale: CGFloat = 1.0
        let minScale: CGFloat = 1.0 // Adjust the minimum scale as needed
        let maxScale: CGFloat = 3.0 // Adjust the maximum scale as needed
        @State var isPanning: Bool = false
        
        // variables for drawing lines
        @State var lines: [Line] = []
        @State private var deletedLines = [Line]()
        @State private var selectedColor = Color.blue
        @State private var selectedLineWidth: CGFloat = 7
        @State private var drawingTool = DrawingTool.pen
        @State private var showConfirmation: Bool = false
        private let pencilCase = PencilCase()
        private let paintBrushCase = PaintbrushCase()
        var lineCap: CGLineCap = .round
        var animal: String
    
        var body: some View {
            VStack {
                Spacer()
                //--------------------Canvas for drawing------------------------
                ZStack {
                    Canvas {ctx, size in
                        for line in lines {
                            // if picked tool is pencil
                            if line.tool == .pencil {
                                connectPointsWithPencil(ctx: ctx, line: line)
                                // if picked tool is paintbrush
                            } else if line.tool == .paintbrush{
                                connectPointsWithPaintBrush(ctx: ctx, line: line)
                                // if picked tool is pen
                            } else if line.tool == .pen {
                                var path = Path()
                                path.addLines(line.points)
                                
                                // style of the line strokes
                                ctx.stroke(path, with: .color(line.color),
                                           style: StrokeStyle(lineWidth: line.lineWidth, lineCap: lineCapIs(tool: line.tool), lineJoin: .round))
                                // if picked tool is eraser
                            }
                        }
                    }
                    .frame(width:390, height: 390)
                    Image(animal).resizable().scaledToFit().border(.black, width: 5).padding(2)
                }
                    // .gesture(DragGesture) actually shows the lines on the canvas and lets you add multiple lines
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({value in
                                if isPanning == false {
                                    let position = value.location
                                    
                                    if value.translation == .zero {
                                        lines.append(Line(tool: drawingTool, points: [position], color: selectedColor, lineWidth: selectedLineWidth))
                                    } else {
                                        guard let lastIdx = lines.indices.last else {
                                            return
                                        }
                                        
                                        lines[lastIdx].points.append(position)
                                    }
                                }
                            }).onEnded({value in
                                // if lines has something
                                if let last = lines.last?.points, last.isEmpty {
                                    lines.removeLast()
                                }
                            })
                        
                    )
                    .offset(offset)
                    .simultaneousGesture(DragGesture().onChanged { value in
                                withAnimation(.spring()){
                                    if isPanning == true {
                                        offset = value.translation
                                    }
                                }
                    })
                    .scaleEffect(scale)
                    .gesture( MagnificationGesture()
                        .onChanged { value in
                            let newScale = scale * value.magnitude
                            scale = min(max(newScale, minScale), maxScale)
                        }
                    )
                    Spacer()
                
                // -----------------top/bottom tool display--------------------
                ZStack {
                    Rectangle()
                        .ignoresSafeArea().offset(y:-700)
                        .frame(width: 395, height: 132)
                        .foregroundColor(Color(hue: 0.0, saturation: 0.0, brightness: 0.75))
                    
                    // bottom tools display
                    Rectangle()
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
//                            Button { drawingTool = .eraser } label: {
//                                Image(systemName: "eraser.fill")
//                                    .font(.title)
//                                    .foregroundColor(drawingTool == .eraser ? .white : .gray)
//                                }
                            Spacer()
                            
                            clearButton().padding(5)
                        
                        }
                        HStack {
                            ForEach([Color.green, .blue, .purple, .red, .orange, .yellow, .black], id: \.self) { color in
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
                                    Image(systemName: "dot.arrowtriangles.up.right.down.left.circle").foregroundColor(.gray).font(.title)
                                }
                            }
                        }
                    }
                }
                    
            }
        }
    
    // ---------------------------buttons----------------------------------
        // clear the whole page function
        func clearButton() -> some View {
            Button {
                showConfirmation = true
            } label: {
                Image(systemName: "clear.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }.confirmationDialog(Text("Are you sure you want to delete your progress?"), isPresented: $showConfirmation) {
                Button("Delete", role: .destructive) {
                    lines = [Line]()
                    deletedLines = [Line]()
                }
            }
        }
    
        // undo function
        func undoButton() -> some View {
            Button {
                // store last lines removed
                let last = lines.removeLast()
                deletedLines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(.title)
                    //.foregroundColor(.gray)
            }.disabled(lines.count == 0)
        }
    
        // redo function
        func redoButton() -> some View {
            Button {
                // append the deleted lines
                let last = deletedLines.removeLast()
                lines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.forward.circle")
                    .font(.title)
                    //.foregroundColor(.gray)
            }.disabled(deletedLines.count == 0)
        }
    
        // color pallete buttons
        func colorButton(color: Color) -> some View {
             Button {
                 selectedColor = color
             } label: {
                 Image(systemName: "circle.fill")
                     .font(.title)
                     .foregroundColor(color)
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

        // determining line cap style
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

#Preview {
    ToolsAndCanvasView(animal: "CC_img01")
}


