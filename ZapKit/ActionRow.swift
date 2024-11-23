//
//  ActionRow.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/22/24.
//

import SwiftUI

struct ActionRow: View {
    let action: Action
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            // Action handling will be implemented later
            print("Selected action: \(action.name)")
        }) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: action.icon)
                        .frame(width: 24)
                        .foregroundColor(isHovered ? .white : action.category.color)
                    Text(action.name)
                        .foregroundColor(isHovered ? .white : .primary)
                    Spacer()
                }
                
                Text(action.description)
                    .font(.caption)
                    .foregroundColor(isHovered ? .white.opacity(0.8) : .secondary)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isHovered ? action.category.color : Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}