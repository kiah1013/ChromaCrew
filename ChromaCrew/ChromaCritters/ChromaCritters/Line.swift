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

struct Line {
    let tool: DrawingTool
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
    
}


