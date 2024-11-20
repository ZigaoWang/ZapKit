//
//  SideBarView.swift
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
            .tag(action)
            .onTapGesture {
                processor.selectedAction = action
            }
            .background(processor.selectedAction == action ? Color.accentColor.opacity(0.2) : Color.clear)
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200, maxWidth: 300)
    }
}
