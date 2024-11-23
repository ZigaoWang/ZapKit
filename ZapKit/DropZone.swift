//
//  ContentView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/22/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DropZone: View {
    @Binding var files: [URL]
    @State private var isTargeted = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .foregroundColor(isTargeted ? .blue : .gray)
                .padding()
            
            VStack {
                Image(systemName: "arrow.down.doc")
                    .font(.system(size: 48))
                Text("Drop files here")
                    .font(.title2)
            }
        }
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers -> Bool in
            for provider in providers {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier) { (urlData, error) in
                    guard let urlData = urlData as? Data,
                          let path = String(data: urlData, encoding: .utf8),
                          let url = URL(string: path) else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if !files.contains(url) {
                            files.append(url)
                        }
                    }
                }
            }
            return true
        }
        .onTapGesture {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            
            if panel.runModal() == .OK {
                files.append(contentsOf: panel.urls)
            }
        }
    }
}

#Preview {
    DropZone(files: .constant([]))
        .frame(width: 400, height: 300)
}
