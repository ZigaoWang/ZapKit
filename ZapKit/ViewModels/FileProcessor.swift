//
//  FileProcessor.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreImage
import CoreImage.CIFilterBuiltins

class FileProcessor: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var selectedAction: ActionType?
    @Published var isProcessing = false
    @Published var showFileImporter = false

    // Processing settings
    @Published var compressionQuality: Double = 0.7
    @Published var resizeWidth: Double = 800
    @Published var brightnessAmount: Double = 0.0
    @Published var rotationAngle: Double = 0
    @Published var isGrayscale = false
    @Published var selectedFilterType: FilterType = .sepia

    private let context = CIContext()

    func addFiles(_ urls: [URL]) {
        let newFiles = urls.map { FileItem(url: $0) }
        DispatchQueue.main.async {
            self.files.append(contentsOf: newFiles)
        }
    }

    func processFiles() {
        guard let action = selectedAction, !files.isEmpty else { return }

        isProcessing = true

        DispatchQueue.global(qos: .userInitiated).async {
            for index in self.files.indices {
                self.updateStatus(at: index, .processing)
                do {
                    let file = self.files[index]
                    let outputURL = try self.processFile(file: file, with: action)
                    self.updateFileAndStatus(at: index, outputURL: outputURL, status: .completed)
                } catch {
                    self.updateStatus(at: index, .error(error.localizedDescription))
                }
            }
            DispatchQueue.main.async {
                self.isProcessing = false
            }
        }
    }

    private func processFile(file: FileItem, with action: ActionType) throws -> URL {
        guard let image = NSImage(contentsOf: file.url) else {
            throw ProcessingError.failedToLoadImage
        }

        var outputURL: URL

        switch action {
        case .compressImage:
            outputURL = try self.compressImage(image, originalURL: file.url)
        case .resizeImage:
            outputURL = try self.resizeImage(image, originalURL: file.url)
        case .convertToPNG:
            outputURL = try self.convertImage(image, to: .png, originalURL: file.url)
        case .convertToJPG:
            outputURL = try self.convertImage(image, to: .jpeg, originalURL: file.url)
        case .adjustBrightness:
            outputURL = try self.adjustBrightness(image, originalURL: file.url)
        case .rotateImage:
            outputURL = try self.rotateImage(image, originalURL: file.url)
        case .applyFilter:
            outputURL = try self.applyFilter(image, originalURL: file.url)
        case .convertToGrayscale:
            outputURL = try self.convertToGrayscale(image, originalURL: file.url)
        }

        return outputURL
    }

    // MARK: - Processing Methods

    private func compressImage(_ image: NSImage, originalURL: URL) throws -> URL {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality]) else {
            throw ProcessingError.compressionFailed
        }

        let outputURL = getOutputURL(originalURL: originalURL, suffix: "_compressed", extension: "jpg")
        try data.write(to: outputURL)
        return outputURL
    }

    private func resizeImage(_ image: NSImage, originalURL: URL) throws -> URL {
        let newSize = NSSize(width: CGFloat(resizeWidth), height: CGFloat(resizeWidth) * image.size.height / image.size.width)
        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize))
        resizedImage.unlockFocus()

        guard let tiffData = resizedImage.tiffRepresentation else {
            throw ProcessingError.resizeFailed
        }

        let outputURL = getOutputURL(originalURL: originalURL, suffix: "_resized", extension: "png")
        try tiffData.write(to: outputURL)
        return outputURL
    }

    private func convertImage(_ image: NSImage, to type: NSBitmapImageRep.FileType, originalURL: URL) throws -> URL {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let data = bitmap.representation(using: type, properties: [:]) else {
            throw ProcessingError.conversionFailed
        }

        let ext = type == .png ? "png" : "jpg"
        let suffix = type == .png ? "_png" : "_jpg"
        let outputURL = getOutputURL(originalURL: originalURL, suffix: suffix, extension: ext)
        try data.write(to: outputURL)
        return outputURL
    }

    private func adjustBrightness(_ image: NSImage, originalURL: URL) throws -> URL {
        guard let inputCIImage = CIImage(data: image.tiffRepresentation!) else {
            throw ProcessingError.adjustmentFailed
        }
        let filter = CIFilter.colorControls()
        filter.inputImage = inputCIImage
        filter.brightness = Float(brightnessAmount)
        guard let outputImage = filter.outputImage else {
            throw ProcessingError.adjustmentFailed
        }
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let brightImage = NSImage(cgImage: cgImage, size: image.size)

        guard let tiffData = brightImage.tiffRepresentation else {
            throw ProcessingError.adjustmentFailed
        }

        let outputURL = getOutputURL(originalURL: originalURL, suffix: "_brightened", extension: "png")
        try tiffData.write(to: outputURL)
        return outputURL
    }

    private func rotateImage(_ image: NSImage, originalURL: URL) throws -> URL {
        let rotatedImage = NSImage(size: image.size)
        rotatedImage.lockFocus()
        let transform = NSAffineTransform()
        transform.rotate(byDegrees: CGFloat(rotationAngle))
        transform.concat()
        image.draw(at: NSZeroPoint, from: NSRect(origin: .zero, size: image.size), operation: .copy, fraction: 1.0)
        rotatedImage.unlockFocus()

        guard let tiffData = rotatedImage.tiffRepresentation else {
            throw ProcessingError.rotationFailed
        }

        let outputURL = getOutputURL(originalURL: originalURL, suffix: "_rotated", extension: "png")
        try tiffData.write(to: outputURL)
        return outputURL
    }

    private func applyFilter(_ image: NSImage, originalURL: URL) throws -> URL {
    guard let inputCIImage = CIImage(data: image.tiffRepresentation!) else {
        throw ProcessingError.filterFailed
    }
    let filter = selectedFilterType.filter
    filter.setValue(inputCIImage, forKey: kCIInputImageKey)
    guard let outputImage = filter.outputImage else {
        throw ProcessingError.filterFailed
    }
    let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
    let filteredImage = NSImage(cgImage: cgImage, size: image.size)

    guard let tiffData = filteredImage.tiffRepresentation else {
        throw ProcessingError.filterFailed
    }

    let outputURL = getOutputURL(originalURL: originalURL, suffix: "_filtered", extension: "png")
    try tiffData.write(to: outputURL)
    return outputURL
}

    private func convertToGrayscale(_ image: NSImage, originalURL: URL) throws -> URL {
        guard let inputCIImage = CIImage(data: image.tiffRepresentation!) else {
            throw ProcessingError.conversionFailed
        }
        let filter = CIFilter.photoEffectMono()
        filter.inputImage = inputCIImage
        guard let outputImage = filter.outputImage else {
            throw ProcessingError.conversionFailed
        }
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let grayscaleImage = NSImage(cgImage: cgImage, size: image.size)

        guard let tiffData = grayscaleImage.tiffRepresentation else {
            throw ProcessingError.conversionFailed
        }

        let outputURL = getOutputURL(originalURL: originalURL, suffix: "_grayscale", extension: "png")
        try tiffData.write(to: outputURL)
        return outputURL
    }

    // MARK: - Helper Methods

    private func updateStatus(at index: Int, _ status: FileItem.ProcessingStatus) {
        DispatchQueue.main.async {
            self.files[index].status = status
        }
    }

    private func updateFileAndStatus(at index: Int, outputURL: URL, status: FileItem.ProcessingStatus) {
        DispatchQueue.main.async {
            self.files[index].processedURL = outputURL
            self.files[index].status = status
        }
    }

    private func getOutputURL(originalURL: URL, suffix: String, extension ext: String) -> URL {
        let fileName = originalURL.deletingPathExtension().lastPathComponent
        let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        return downloadsURL.appendingPathComponent("\(fileName)\(suffix).\(ext)")
    }

    // MARK: - Error Handling

    private enum ProcessingError: LocalizedError {
        case failedToLoadImage
        case compressionFailed
        case resizeFailed
        case conversionFailed
        case adjustmentFailed
        case rotationFailed
        case filterFailed

        var errorDescription: String? {
            switch self {
            case .failedToLoadImage: return "Failed to load image"
            case .compressionFailed: return "Failed to compress image"
            case .resizeFailed: return "Failed to resize image"
            case .conversionFailed: return "Failed to convert image"
            case .adjustmentFailed: return "Failed to adjust image"
            case .rotationFailed: return "Failed to rotate image"
            case .filterFailed: return "Failed to apply filter"
            }
        }
    }
}