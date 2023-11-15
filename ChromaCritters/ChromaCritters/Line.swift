//
//  Line.swift
//  drawingApp
//
//  Created by Krisma Antonio on 9/17/23.
//

import SwiftUI

enum DrawingTool: Codable {
    case pen
    case pencil
    case paintbrush
    case eraser
}

struct Line: Identifiable, Codable {
    let tool: DrawingTool
    var points: [CGPoint]
    var color: Color {
        get {
            customColor.color
        }
        set {
            customColor = CustomColor(color: newValue)
        }
    }
    private var customColor: CustomColor
    var lineWidth: CGFloat
    let id: UUID
    
    init(tool: DrawingTool, points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.tool = tool
        self.points = points
        self.customColor = CustomColor(color: color)
        self.lineWidth = lineWidth
        self.id = UUID()
    }
    
    
}

struct CustomColor: Codable {
    var green: Double = 0.5
    var blue: Double = 0
    var red: Double = 1
    var opacity: Double = 1
    
    init(color: Color) {
        if let components = color.cgColor?.components {
            if components.count > 2 {
                self.red = components[0]
                self.green = components[1]
                self.blue = components[2]
            }
            if components.count > 3 {
                self.opacity = components[3]
            }
        }
    }
    
    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
