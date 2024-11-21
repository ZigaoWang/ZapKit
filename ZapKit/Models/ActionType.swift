//
//  ActionType.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

enum ActionType: String, CaseIterable, Identifiable {
    case compressImage = "Compress Image"
    case resizeImage = "Resize Image"
    case convertToPNG = "Convert to PNG"
    case convertToJPG = "Convert to JPEG"
    case adjustBrightness = "Adjust Brightness"
    case rotateImage = "Rotate Image"
    case applyFilter = "Apply Filter"
    case convertToGrayscale = "Convert to Grayscale"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .compressImage: return "arrow.down.circle"
        case .resizeImage: return "aspectratio"
        case .convertToPNG: return "doc.richtext"
        case .convertToJPG: return "doc.plaintext"
        case .adjustBrightness: return "sun.max"
        case .rotateImage: return "rotate.right"
        case .applyFilter: return "wand.and.stars"
        case .convertToGrayscale: return "circle.lefthalf.fill"
        }
    }
}