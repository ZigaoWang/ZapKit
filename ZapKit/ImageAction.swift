//
//  ImageAction.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/23/24.
//

import Foundation
import AppKit
import UniformTypeIdentifiers
import SwiftUI

enum ImageAction: String {
    case compress = "Compress"
    case convertPNG = "Convert to PNG"
    case resize = "Resize"
    
    var icon: String {
        switch self {
        case .compress: return "arrow.down.circle"
        case .convertPNG: return "arrow.triangle.2.circlepath"
        case .resize: return "arrow.up.left.and.arrow.down.right"
        }
    }
    
    var color: Color {
        switch self {
        case .compress: return .blue
        case .convertPNG: return .green
        case .resize: return .orange
        }
    }
    
    var description: String {
        switch self {
        case .compress: return "Reduce file size"
        case .convertPNG: return "Convert to PNG format"
        case .resize: return "Resize image dimensions"
        }
    }
    
    func process(_ url: URL) async throws -> URL {
        // 创建临时输出路径
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("processed_\(url.lastPathComponent)")
        
        // 读取原始图片
        guard let image = NSImage(contentsOf: url) else {
            throw ProcessError.invalidImage
        }
        
        // 根据操作类型处理图片
        switch self {
        case .compress:
            try await compressImage(image, to: outputURL)
        case .convertPNG:
            try await convertToPNG(image, to: outputURL)
        case .resize:
            try await resizeImage(image, to: outputURL)
        }
        
        return outputURL
    }
    
    private func compressImage(_ image: NSImage, to url: URL) async throws {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let destination = CGImageDestinationCreateWithURL(
                url as CFURL,
                UTType.jpeg.identifier as CFString,
                1,
                nil
              ) else {
            throw ProcessError.compressionFailed
        }
        
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: 0.7
        ]
        
        CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
        
        if !CGImageDestinationFinalize(destination) {
            throw ProcessError.compressionFailed
        }
    }
    
    private func convertToPNG(_ image: NSImage, to url: URL) async throws {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let destination = CGImageDestinationCreateWithURL(
                url as CFURL,
                UTType.png.identifier as CFString,
                1,
                nil
              ) else {
            throw ProcessError.conversionFailed
        }
        
        CGImageDestinationAddImage(destination, cgImage, nil)
        
        if !CGImageDestinationFinalize(destination) {
            throw ProcessError.conversionFailed
        }
    }
    
    private func resizeImage(_ image: NSImage, to url: URL) async throws {
        // 这里简单地将图片调整为原来的一半大小
        let newSize = NSSize(
            width: image.size.width * 0.5,
            height: image.size.height * 0.5
        )
        
        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        
        NSGraphicsContext.current?.imageInterpolation = .high
        image.draw(in: NSRect(origin: .zero, size: newSize))
        
        resizedImage.unlockFocus()
        
        guard let tiffData = resizedImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]),
              (try? pngData.write(to: url)) != nil else {
            throw ProcessError.resizeFailed
        }
    }
}

enum ProcessError: Error, LocalizedError {
    case invalidImage
    case compressionFailed
    case conversionFailed
    case resizeFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Unable to load the image"
        case .compressionFailed:
            return "Failed to compress the image"
        case .conversionFailed:
            return "Failed to convert the image"
        case .resizeFailed:
            return "Failed to resize the image"
        }
    }
}
