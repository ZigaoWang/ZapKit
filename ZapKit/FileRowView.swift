//
//  FileRowView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/23/24.
//

import SwiftUI

struct FileRowView: View {
    let url: URL
    
    var body: some View {
        HStack {
            Image(systemName: "doc")
            VStack(alignment: .leading) {
                Text(url.lastPathComponent)
                Text(url.pathExtension.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
