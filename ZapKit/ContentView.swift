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
    @State private var processedURL: URL?
    @State private var selectedAction: FileAction?
    @State private var showProcessingSheet = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationSplitView {
            // Left Sidebar - File List
            VStack {
                if droppedFiles.isEmpty {
                    DropZone(files: $droppedFiles)
                } else {
                    List(droppedFiles, id: \.self, selection: $selectedFile) { file in
                        FileRowView(url: file)
                    }
                    .listStyle(.inset)
                    
                    HStack {
                        Button(action: {
                            droppedFiles.removeAll()
                            selectedFile = nil
                            processedURL = nil
                        }) {
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
                VStack(spacing: 0) {
                    // Preview
                    ScrollView {
                        if let image = NSImage(contentsOf: selectedFile) {
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    }
                    
                    Divider()
                    
                    // Quick Actions
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FileAction.quickActions) { action in
                                QuickActionButton(action: action) {
                                    selectedAction = action
                                    showProcessingSheet = true
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color(NSColor.controlBackgroundColor))
                }
            } else {
                EmptySelectionView()
            }
        } detail: {
            // Right Side - Advanced Actions & Settings
            if selectedFile != nil {
                VStack {
                    // Actions Groups
                    List {
                        Section("Image Processing") {
                            ForEach(FileAction.imageActions) { action in
                                ActionRowView(action: action) {
                                    selectedAction = action
                                    showProcessingSheet = true
                                }
                            }
                        }
                        
                        Section("Conversion") {
                            ForEach(FileAction.conversionActions) { action in
                                ActionRowView(action: action) {
                                    selectedAction = action
                                    showProcessingSheet = true
                                }
                            }
                        }
                        
                        Section("Optimization") {
                            ForEach(FileAction.optimizationActions) { action in
                                ActionRowView(action: action) {
                                    selectedAction = action
                                    showProcessingSheet = true
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Processing History
                    if let processedURL = processedURL {
                        ProcessingResultView(originalURL: selectedFile!, processedURL: processedURL)
                            .padding()
                    }
                }
            } else {
                EmptySelectionView()
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $showProcessingSheet) {
            if let action = selectedAction,
               let file = selectedFile {
                ProcessingView(
                    url: file,
                    action: action,
                    processedURL: $processedURL,
                    isPresented: $showProcessingSheet
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let action: FileAction
    let onTap: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: action.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isHovered ? .white : action.category.color)
                Text(action.name)
                    .font(.caption)
                    .foregroundColor(isHovered ? .white : .primary)
            }
            .padding()
            .background(isHovered ? action.category.color : Color(NSColor.controlBackgroundColor))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Action Row View
struct ActionRowView: View {
    let action: FileAction
    let onTap: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: action.icon)
                    .foregroundColor(action.category.color)
                    .frame(width: 24)
                
                VStack(alignment: .leading) {
                    Text(action.name)
                    Text(action.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .opacity(isHovered ? 1 : 0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Processing Result View
struct ProcessingResultView: View {
    let originalURL: URL
    let processedURL: URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last Processing Result")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Original Size:")
                    Text("New Size:")
                    Text("Saved:")
                }
                .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    Text(getFileSize(originalURL))
                    Text(getFileSize(processedURL))
                    Text(calculateSavings())
                        .foregroundColor(.green)
                }
            }
            
            HStack {
                Button("Show in Finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([processedURL])
                }
                
                Button("Save As...") {
                    saveProcessedFile()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
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
        if let originalAttributes = try? FileManager.default.attributesOfItem(atPath: originalURL.path),
           let processedAttributes = try? FileManager.default.attributesOfItem(atPath: processedURL.path),
           let originalSize = originalAttributes[.size] as? Int64,
           let processedSize = processedAttributes[.size] as? Int64 {
            let savedBytes = originalSize - processedSize
            let percentage = Double(savedBytes) / Double(originalSize) * 100
            return String(format: "%.1f%% (%.2f MB)", percentage, Double(savedBytes) / 1_000_000)
        }
        return "Unknown"
    }
    
    private func saveProcessedFile() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "processed_\(originalURL.lastPathComponent)"
        
        if savePanel.runModal() == .OK {
            if let url = savePanel.url {
                try? FileManager.default.copyItem(at: processedURL, to: url)
            }
        }
    }
}

// MARK: - Empty Selection View
struct EmptySelectionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Select a file to start processing")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
