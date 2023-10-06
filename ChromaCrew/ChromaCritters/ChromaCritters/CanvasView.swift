//
//  CanvasView.swift
//  Sprint1
//
//  Created by Krisma Antonio on 10/2/23.
//

import SwiftUI

struct CanvasView: View {
    @State private var lines: [Line] = []
    @State private var selectedColor = Color.blue
    @State private var selectedLineWidth: CGFloat = 7
    @State private var drawingTool = DrawingTool.pen

    private let pencilCase = PencilCase()
    var animal: String
    var lineCap:CGLineCap = .round
    
    var body: some View {
        ZStack {
            Canvas {ctx, size in
                for line in lines {
                    // if picked tool is pencil, do this
                    if line.tool == .pencil{
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
        ).offset(y:150)
        
        ToolsView()
    
    }
    func lineCapIs(tool: DrawingTool) -> CGLineCap {
        tool == .marker ? .square : .round
    }
    
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
    CanvasView(animal: "dog")
}

