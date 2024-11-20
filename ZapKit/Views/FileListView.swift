//
//  FileListView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct FileListView: View {
    @ObservedObject var processor: FileProcessor
    
    var body: some View {
        List(processor.files) { file in
            FileRowView(file: file)
        }
        .listStyle(InsetListStyle())
        .frame(minWidth: 300)
    }
}

struct FileRowView: View {
    let file: FileItem
    
    var body: some View {
        HStack {
            Image(systemName: "doc")
            VStack(alignment: .leading) {
                Text(file.url.lastPathComponent)
                    .font(.headline)
                Text(file.url.pathExtension.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            StatusView(status: file.status)
        }
        .padding(.vertical, 4)
    }
}
