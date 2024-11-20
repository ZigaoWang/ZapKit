//
//  FilePreviewView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct FilePreviewView: View {
    let file: FileItem
    @State private var image: NSImage?
    
    private let supportedImageExtensions = ["jpg", "jpeg", "png", "gif"]
    
    var body: some View {
        VStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Preview Available")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let fileExtension = file.url.pathExtension.lowercased()
        if supportedImageExtensions.contains(fileExtension) {
            image = NSImage(contentsOf: file.url)
        }
    }
}
