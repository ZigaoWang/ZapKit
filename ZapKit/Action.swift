//
//  Action.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/22/24.
//

import SwiftUI

struct Action: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
    let category: ActionCategory
    
    enum ActionCategory {
        case image
        case file
        case convert
        
        var color: Color {
            switch self {
            case .image: return .blue
            case .file: return .green
            case .convert: return .orange
            }
        }
    }
}