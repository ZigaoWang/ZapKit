//
//  FilePreviewView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/22/24.
//

import SwiftUI
import Quartz
import UniformTypeIdentifiers

struct FilePreviewView: View {
    let url: URL
    let processedURL: URL?
    @State private var isProcessing = false
    @State private var showSaveDialog = false
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Preview area
            GeometryReader { geometry in
                ZStack {
                    if let processedURL = processedURL {
                        HStack {
                            // Original preview
                            VStack {
                                Text("Original")
                                    .font(.headline)
                                PreviewItem(url: url, size: geometry.size)
                            }
                            
                            // Divider
                            Rectangle()
                                .frame(width: 1)
                                .foregroundColor(.gray.opacity(0.3))
                            
                            // Processed preview
                            VStack {
                                Text("Processed")
                                    .font(.headline)
                                PreviewItem(url: processedURL, size: geometry.size)
                            }
                        }
                    } else {
                        PreviewItem(url: url, size: geometry.size)
                    }
                    
                    if isProcessing {
                        ProcessingOverlay()
                    }
                }
            }
            
            // Action buttons
            if processedURL != nil {
                HStack(spacing: 16) {
                    Button(action: { showSaveDialog = true }) {
                        Label("Save As", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        NSWorkspace.shared.activateFileViewerSelecting([processedURL!])
                    }) {
                        Label("Show in Finder", systemImage: "folder")
                    }
                }
                .padding()
            }
        }
        .fileExporter(
            isPresented: $showSaveDialog,
            document: ProcessedFile(url: processedURL!),
            contentType: .image,
            defaultFilename: "Processed_\(url.lastPathComponent)"
        ) { result in
            switch result {
            case .success(let url):
                print("Saved to: \(url)")
            case .failure(let error):
                print("Save error: \(error)")
            }
        }
    }
}

struct PreviewItem: View {
    let url: URL
    let size: CGSize
    
    var body: some View {
        if let image = NSImage(contentsOf: url) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: size.width * 0.9, maxHeight: size.height * 0.9)
        } else {
            QuickLookPreview(url: url)
                .frame(maxWidth: size.width * 0.9, maxHeight: size.height * 0.9)
        }
    }
}

struct ProcessingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                Text("Processing...")
                    .foregroundColor(.white)
            }
        }
    }
}

struct QuickLookPreview: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> QLPreviewView {
        let preview = QLPreviewView(frame: .zero, style: .normal)!
        preview.autostarts = true
        preview.previewItem = url as QLPreviewItem
        return preview
    }
    
    func updateNSView(_ nsView: QLPreviewView, context: Context) {
        nsView.previewItem = url as QLPreviewItem
    }
}

struct ProcessedFile: FileDocument {
    let url: URL
    
    static var readableContentTypes: [UTType] { [.image] }
    
    init(url: URL) {
        self.url = url
    }
    
    init(configuration: ReadConfiguration) throws {
        url = URL(fileURLWithPath: "")
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        try FileWrapper(url: url, options: .immediate)
    }
}

#Preview {
    FilePreviewView(
        url: URL(fileURLWithPath: ""),
        processedURL: nil
    )
}