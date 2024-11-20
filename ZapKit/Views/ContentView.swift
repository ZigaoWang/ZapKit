//
//  ContentView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var processor = FileProcessor()
    @State private var dragOver = false
    
    var body: some View {
        NavigationView {
            SidebarView(processor: processor)
            
            if processor.files.isEmpty {
                EmptyStateView()
                    .onDrop(of: [UTType.fileURL.identifier], isTargeted: $dragOver) { providers in
                        Task {
                            var urls: [URL] = []
                            for provider in providers {
                                if let itemIdentifier = provider.registeredTypeIdentifiers.first {
                                    if let urlData = try? await provider.loadItem(forTypeIdentifier: itemIdentifier, options: nil) as? Data {
                                        if let url = URL(dataRepresentation: urlData, relativeTo: nil) {
                                            urls.append(url)
                                        }
                                    }
                                }
                            }
                            processor.addFiles(urls)
                        }
                        return true
                    }
            } else {
                FileListView(processor: processor)
            }
            
            if let selectedFile = processor.files.first {
                FilePreviewView(file: selectedFile)
            } else {
                Text("Select a file to preview")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("ZapKit")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: processor.processFiles) {
                    Label("Process", systemImage: "play.fill")
                }
                .disabled(processor.files.isEmpty || processor.selectedAction == nil)
            }
            
            ToolbarItem(placement: .automatic) {
                Button(action: showFilePicker) {
                    Label("Open Files", systemImage: "folder")
                }
            }
        }
    }
    
    private func showFilePicker() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image]
        
        if panel.runModal() == .OK {
            processor.addFiles(panel.urls)
        }
    }
}
