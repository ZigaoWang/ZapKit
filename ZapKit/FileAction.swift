//
//  FileAction.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/23/24.
//

import SwiftUI

struct FileAction: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
    let category: ActionCategory
    let processor: (URL) async throws -> URL
    
    enum ActionCategory {
        case image
        case convert
        case compress
        
        var color: Color {
            switch self {
            case .image: return .blue
            case .convert: return .green
            case .compress: return .orange
            }
        }
    }
    
    static let quickActions: [FileAction] = [
        FileAction(
            name: "Compress",
            icon: "arrow.down.circle",
            description: "Quick compression",
            category: .compress,
            processor: defaultProcessor
        ),
        FileAction(
            name: "Convert",
            icon: "arrow.triangle.2.circlepath",
            description: "Convert format",
            category: .convert,
            processor: defaultProcessor
        ),
        FileAction(
            name: "Resize",
            icon: "arrow.up.left.and.arrow.down.right",
            description: "Quick resize",
            category: .image,
            processor: defaultProcessor
        )
    ]
    
    static let imageActions: [FileAction] = [
        FileAction(
            name: "Resize Image",
            icon: "arrow.up.left.and.arrow.down.right.square",
            description: "Change image dimensions",
            category: .image,
            processor: defaultProcessor
        ),
        FileAction(
            name: "Crop Image",
            icon: "crop",
            description: "Crop image to specific size",
            category: .image,
            processor: defaultProcessor
        ),
        FileAction(
            name: "Rotate Image",
            icon: "rotate.right",
            description: "Rotate image",
            category: .image,
            processor: defaultProcessor
        )
    ]
    
    static let conversionActions: [FileAction] = [
        FileAction(
            name: "Convert to PNG",
            icon: "doc.viewfinder",
            description: "Convert to PNG format",
            category: .convert,
            processor: defaultProcessor
        ),
        FileAction(
            name: "Convert to JPEG",
            icon: "doc.viewfinder",
            description: "Convert to JPEG format",
            category: .convert,
            processor: defaultProcessor
        )
    ]
    
    static let optimizationActions: [FileAction] = [
        FileAction(
            name: "Compress Image",
            icon: "arrow.down.circle",
            description: "Reduce file size",
            category: .compress,
            processor: defaultProcessor
        ),
        FileAction(
            name: "Optimize for Web",
            icon: "globe",
            description: "Optimize for web usage",
            category: .compress,
            processor: defaultProcessor
        )
    ]
    
    private static func defaultProcessor(_ url: URL) async throws -> URL {
        // Simulate processing
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let destinationURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("processed_\(url.lastPathComponent)")
        try FileManager.default.copyItem(at: url, to: destinationURL)
        return destinationURL
    }
}
