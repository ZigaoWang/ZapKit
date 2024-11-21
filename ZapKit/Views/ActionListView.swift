//
//  ActionListView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct ActionListView: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        VStack(alignment: .leading) {
            Text("Actions")
                .font(.headline)
                .padding(.top)
            List(ActionType.allCases) { action in
                HStack {
                    Image(systemName: action.icon)
                    Text(action.rawValue)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .background(processor.selectedAction == action ? Color.blue.opacity(0.2) : Color.clear)
                .onTapGesture {
                    processor.selectedAction = action
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
}
