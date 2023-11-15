//
//  PaintbrushCase.swift
//  ChromaCritters
//
//  Created by Krisma Antonio on 10/3/23.
//

import SwiftUI

struct PaintbrushTip: Shape {
    let nLines: Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let lineSpace = rect.width / CGFloat(nLines)
        for i in 0..<nLines {
            var y = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.move(to: CGPoint(x: rect.minX, y: y))
            y = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        return path
    }
}

class PaintbrushCase {

    let nTipsPerSize = 7
    let scalingFactor = CGFloat(20)
    let scaledLineWidth = CGFloat(10)
    let scaledBlurRadius = CGFloat(8)

    typealias Images = [Image]
    typealias PaintbrushTips = [CGFloat: Images]
    private var colorMap = [Color: PaintbrushTips]()

    private func point2TipIndex(_ point: CGPoint) -> Int {
        Int(100 * abs(point.x + point.y)) % nTipsPerSize
    }

    private func scaledRectangle(lineWidth: CGFloat) -> CGRect {
        CGRect(x: 0, y: 0, width: lineWidth * scalingFactor, height: lineWidth * scalingFactor)
    }

    private func createPaintBrushTip(color: Color, lineWidth: CGFloat) -> Image {
        Image(size: CGSize(width: lineWidth, height: lineWidth)) { context in
            context.scaleBy(x: 1.0 / self.scalingFactor, y: 1.0 / self.scalingFactor)
            context.addFilter(.shadow(color: color, radius: self.scaledBlurRadius))
            context.clip(to: Path(ellipseIn: self.scaledRectangle(lineWidth: lineWidth)))
            context.stroke(
                PaintbrushTip(nLines: max(1, Int(lineWidth.squareRoot())))
                    .path(in: self.scaledRectangle(lineWidth: lineWidth)),
                with: .color(color.opacity(0.1)),
                lineWidth: self.scaledLineWidth
            )
        }
    }

    private func createPaintBrushTips(color: Color, lineWidth: CGFloat) -> Images {
        var result = Images()
        result.reserveCapacity(nTipsPerSize)
        for _ in 0..<nTipsPerSize {
            result.append(createPaintBrushTip(color: color, lineWidth: lineWidth))
        }
        return result
    }

    func paintBrushTip(color: Color, lineWidth: CGFloat, point: CGPoint) -> Image {
        let result: Image
        if let paintBrushTips = colorMap[color] {
            if let existingTips = paintBrushTips[lineWidth] {
                result = existingTips[point2TipIndex(point)]
            } else {
                let tips = createPaintBrushTips(color: color, lineWidth: lineWidth)
                colorMap[color]?[lineWidth] = tips
                result = tips[point2TipIndex(point)]
            }
        } else {
            let tips = createPaintBrushTips(color: color, lineWidth: lineWidth)
            colorMap[color] = [lineWidth: tips]
            result = tips[point2TipIndex(point)]
        }
        return result
    }
}

