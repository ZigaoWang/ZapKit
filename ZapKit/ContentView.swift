//
//  ContentView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var droppedFiles: [URL] = []
    @State private var selectedFile: URL?
    @State private var processedFile: URL?
    @State private var isProcessing = false
    @State private var showProcessingSheet = false
    @State private var selectedAction: ImageAction?
    
    var body: some View {
        NavigationSplitView {
            // Left side - File List
            VStack {
                if droppedFiles.isEmpty {
                    DropZone(files: $droppedFiles)
                } else {
                    List(droppedFiles, id: \.self, selection: $selectedFile) { file in
                        FileRowView(url: file)
                    }
                    .listStyle(.inset)
                    
                    HStack {
                        Button(action: clearFiles) {
                            Label("Clear All", systemImage: "trash")
                        }
                        Spacer()
                        Text("\(droppedFiles.count) files")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            .frame(minWidth: 250)
            
        } content: {
            // Middle - Preview & Actions
            if let selectedFile = selectedFile {
                VStack {
                    // Preview
                    ScrollView {
                        if let image = NSImage(contentsOf: selectedFile) {
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    }
                    
                    // Actions
                    VStack(spacing: 20) {
                        Text("Quick Actions")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            ForEach([ImageAction.compress, .convertPNG, .resize], id: \.self) { action in
                                ActionButton(action: action) {
                                    selectedAction = action
                                    showProcessingSheet = true
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                }
            } else {
                EmptyStateView()
            }
            
        } detail: {
            // Right side - Results
            if let processedFile = processedFile {
                ProcessedFileView(originalFile: selectedFile!, processedFile: processedFile)
            } else {
                EmptyStateView()
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $showProcessingSheet) {
            if let action = selectedAction,
               let file = selectedFile {
                ProcessingView(
                    url: file,
                    action: action,
                    processedURL: $processedFile,
                    isPresented: $showProcessingSheet
                )
            }
        }
    }
    
    private func clearFiles() {
        droppedFiles.removeAll()
        selectedFile = nil
        processedFile = nil
        isProcessing = false
    }
}

// MARK: - Supporting Views
struct ActionButton: View {
    let action: ImageAction
    let onTap: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: action.icon)
                    .font(.system(size: 24))
                Text(action.rawValue)
                    .font(.caption)
            }
            .frame(width: 100)
            .padding()
            .background(action.color.opacity(isHovered ? 0.2 : 0.1))
            .foregroundColor(action.color)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

struct ProcessedFileView: View {
    let originalFile: URL
    let processedFile: URL
    
    var body: some View {
        VStack(spacing: 20) {
            GroupBox("Processing Results") {
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow("Original Size", getFileSize(originalFile))
                    InfoRow("New Size", getFileSize(processedFile))
                    InfoRow("Saved", calculateSavings())
                }
                .padding()
            }
            
            HStack {
                Button("Show in Finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([processedFile])
                }
                
                Spacer()
                
                ShareLink(item: processedFile)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .padding()
    }
    
    private func getFileSize(_ url: URL) -> String {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
           let size = attributes[.size] as? Int64 {
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            return formatter.string(fromByteCount: size)
        }
        return "Unknown"
    }
    
    private func calculateSavings() -> String {
        if let originalAttributes = try? FileManager.default.attributesOfItem(atPath: originalFile.path),
           let processedAttributes = try? FileManager.default.attributesOfItem(atPath: processedFile.path),
           let originalSize = originalAttributes[.size] as? Int64,
           let processedSize = processedAttributes[.size] as? Int64 {
            let savedBytes = originalSize - processedSize
            let percentage = Double(savedBytes) / Double(originalSize) * 100
            return String(format: "%.1f%% (%.2f MB)", percentage, Double(savedBytes) / 1_000_000)
        }
        return "Unknown"
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No File Selected")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}