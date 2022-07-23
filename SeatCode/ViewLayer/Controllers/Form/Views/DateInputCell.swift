//
//  TextInputCell2.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import SwiftUI

struct DateInputCell: View {

    typealias Validator = (Date) -> String?

    var title: String?

    @ObservedObject var field: FieldValidator<Date>

    init(title: String = "", value: Binding<Date>, checker: Binding<FieldChecker>, validator: @escaping Validator) {
        self.title = title
        self.field = FieldValidator(value, checker: checker, validator: validator)

    }

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color(R.color.colorGray50Semi.name))
                    .border(field.isValid ? Color.clear : Color.red)
                    .frame(height: 40)
                    .padding(.horizontal, 15)

                ZStack {
                    DatePicker(selection: $field.value, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                        Text("")
                    }
                    .foregroundColor(Color(R.color.colorWhite.name))
                        .padding(.all)
                        .onAppear { self.field.doValidate() }
                }.frame(height: 20)
                    .padding(.horizontal, 20)
            }
            if !field.isValid {
                Text(field.errorMessage ?? "")
                    .fontWeight(.light)
                    .font(.footnote)
                    .foregroundColor(Color.red)
            }
        }
    }
}
