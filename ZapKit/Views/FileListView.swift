//
//  FileListView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileListView: View {
    @ObservedObject var processor: FileProcessor
    @State private var isDragging = false

    var body: some View {
        VStack {
            if processor.files.isEmpty {
                Text("No files added. Drag and drop files here.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List {
                    ForEach(processor.files) { file in
                        HStack {
                            Text(file.url.lastPathComponent)
                            Spacer()
                            StatusView(status: file.status)
                        }
                    }
                    .onDelete(perform: deleteFiles)
                }
            }
        }
        .onDrop(of: [UTType.fileURL], isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
            return true
        }
    }

    private func deleteFiles(at offsets: IndexSet) {
        processor.files.remove(atOffsets: offsets)
    }

    private func handleDrop(providers: [NSItemProvider]) {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                        processor.addFiles([url])
                    }
                }
            }
        }
    }
}