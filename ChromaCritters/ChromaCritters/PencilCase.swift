//
//  PencilCase.swift
//  Sprint1
//
//  Created by Krisma Antonio on 9/26/23.
//
import SwiftUI

// This whole file is just for creating the texture of the pencil case //

struct PencilTip: Shape {
    let nLines: Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let lineSpace = rect.width / CGFloat(nLines)
        for i in 0..<nLines {
            var x = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.move(to: CGPoint(x: x, y: rect.minY))
            x = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
            var y = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.move(to: CGPoint(x: rect.minX, y: y))
            y = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        return path
    }
}

class PencilCase {

    let nTipsPerSize = 7
    let scalingFactor = CGFloat(20)
    let scaledLineWidth = CGFloat(10)
    let scaledBlurRadius = CGFloat(8)

    typealias Images = [Image]
    typealias PencilTips = [CGFloat: Images]
    private var colorMap = [Color: PencilTips]()

    private func point2TipIndex(_ point: CGPoint) -> Int {
        Int(100 * abs(point.x + point.y)) % nTipsPerSize
    }

    private func scaledRectangle(lineWidth: CGFloat) -> CGRect {
        CGRect(x: 0, y: 0, width: lineWidth * scalingFactor, height: lineWidth * scalingFactor)
    }

    private func createPencilTip(color: Color, lineWidth: CGFloat) -> Image {
        Image(size: CGSize(width: lineWidth, height: lineWidth)) { context in
            context.scaleBy(x: 1.0 / self.scalingFactor, y: 1.0 / self.scalingFactor)
            context.addFilter(.shadow(color: color, radius: self.scaledBlurRadius))
            context.clip(to: Path(ellipseIn: self.scaledRectangle(lineWidth: lineWidth)))
            context.stroke(
                PencilTip(nLines: max(1, Int(lineWidth.squareRoot())))
                    .path(in: self.scaledRectangle(lineWidth: lineWidth)),
                with: .color(color.opacity(0.8)),
                lineWidth: self.scaledLineWidth
            )
        }
    }

    private func createPencilTips(color: Color, lineWidth: CGFloat) -> Images {
        var result = Images()
        result.reserveCapacity(nTipsPerSize)
        for _ in 0..<nTipsPerSize {
            result.append(createPencilTip(color: color, lineWidth: lineWidth))
        }
        return result
    }

    func pencilTip(color: Color, lineWidth: CGFloat, point: CGPoint) -> Image {
        let result: Image
        if let pencilTips = colorMap[color] {
            if let existingTips = pencilTips[lineWidth] {
                result = existingTips[point2TipIndex(point)]
            } else {
                let tips = createPencilTips(color: color, lineWidth: lineWidth)
                colorMap[color]?[lineWidth] = tips
                result = tips[point2TipIndex(point)]
            }
        } else {
            let tips = createPencilTips(color: color, lineWidth: lineWidth)
            colorMap[color] = [lineWidth: tips]
            result = tips[point2TipIndex(point)]
        }
        return result
    }
}
