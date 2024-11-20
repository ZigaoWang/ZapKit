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
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .compressImage: return "arrow.down.circle"
        case .resizeImage: return "arrow.up.left.and.arrow.down.right"
        case .convertToPNG: return "doc.on.doc"
        case .convertToJPG: return "doc.on.doc.fill"
        case .adjustBrightness: return "sun.max"
        case .rotateImage: return "rotate.right"
        }
    }
}
