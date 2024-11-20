//
//  FileProcessor.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

class FileProcessor: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var selectedAction: ActionType?
    @Published var isProcessing = false
    
    func addFiles(_ urls: [URL]) {
        let newFiles = urls.map { FileItem(url: $0) }
        DispatchQueue.main.async {
            self.files.append(contentsOf: newFiles)
        }
    }
    
    func processFiles() {
        guard let action = selectedAction, !files.isEmpty else { return }
        
        isProcessing = true
        
        for (index, file) in files.enumerated() {
            var updatedFile = file
            updatedFile.status = .processing
            files[index] = updatedFile
            
            DispatchQueue.global(qos: .userInitiated).async {
                switch action {
                case .compressImage:
                    self.compressImage(at: index)
                case .resizeImage:
                    self.resizeImage(at: index)
                case .convertToPNG:
                    self.convertToPNG(at: index)
                case .convertToJPG:
                    self.convertToJPG(at: index)
                case .adjustBrightness:
                    self.adjustBrightness(at: index)
                case .rotateImage:
                    self.rotateImage(at: index)
                }
            }
        }
    }
    
    private func compressImage(at index: Int) {
        if NSImage(contentsOf: files[index].url) != nil {
            // TODO: Implement actual compression
            DispatchQueue.main.async {
                self.files[index].status = .completed
                self.isProcessing = false
            }
        } else {
            DispatchQueue.main.async {
                self.files[index].status = .error("Failed to load image")
                self.isProcessing = false
            }
        }
    }
    
    private func resizeImage(at index: Int) {
        if NSImage(contentsOf: files[index].url) != nil {
            // TODO: Implement actual resizing
            DispatchQueue.main.async {
                self.files[index].status = .completed
                self.isProcessing = false
            }
        } else {
            DispatchQueue.main.async {
                self.files[index].status = .error("Failed to load image")
                self.isProcessing = false
            }
        }
    }
    
    private func convertToPNG(at index: Int) {
        // TODO: Implement PNG conversion
        DispatchQueue.main.async {
            self.files[index].status = .completed
            self.isProcessing = false
        }
    }
    
    private func convertToJPG(at index: Int) {
        // TODO: Implement JPG conversion
        DispatchQueue.main.async {
            self.files[index].status = .completed
            self.isProcessing = false
        }
    }
    
    private func adjustBrightness(at index: Int) {
        // TODO: Implement brightness adjustment
        DispatchQueue.main.async {
            self.files[index].status = .completed
            self.isProcessing = false
        }
    }
    
    private func rotateImage(at index: Int) {
        // TODO: Implement image rotation
        DispatchQueue.main.async {
            self.files[index].status = .completed
            self.isProcessing = false
        }
    }
}
