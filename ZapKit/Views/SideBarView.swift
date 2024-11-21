//
//  SidebarView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct SidebarView: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        List(ActionType.allCases) { action in
            HStack {
                Image(systemName: action.icon)
                Text(action.rawValue)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .background(processor.selectedAction == action ? Color.accentColor.opacity(0.2) : Color.clear)
            .onTapGesture {
                processor.selectedAction = action
            }
        }
        .listStyle(SidebarListStyle())
    }
}