//
//  ActionCell.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import SwiftUI

struct ActionCell: View {
    var isEnabled: Bool
    var onAction: () -> Void = { /* Default empty block */ }
    var body: some View {

        ZStack {
            Rectangle()
                .fill(Color(R.color.colorRed.name))
                .border(Color.red)
                .frame(height: 40)
                .padding(.horizontal, 15)
                .opacity(isEnabled ? 1 : 0)
            Button(action: {
                self.onAction()
            }, label: {
                Text(R.string.localizable.issue_button_save.key.localized)
                    .foregroundColor(Color(R.color.colorWhite.name))
            }).disabled(!isEnabled)
        }
    }
}

struct ActionCell_Previews: PreviewProvider {
    static var previews: some View {
        ActionCell(isEnabled: false)
    }
}
