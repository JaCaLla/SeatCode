//
//  MultilineInputCell2.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import SwiftUI

struct MultilineInputCell: View {

    typealias Validator = (String) -> String?

    var title: String?

    @ObservedObject var field: FieldValidator<String>

    init(title: String = "", value: Binding<String>, checker: Binding<FieldChecker>, validator: @escaping Validator) {
        self.title = title
        self.field = FieldValidator(value, checker: checker, validator: validator)
    }

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color(R.color.colorGray50Semi.name))
                    .border(Color(field.isValid ? R.color.colorClear.name : R.color.colorRed.name))
                    .frame(height: 100)
                    .padding(.horizontal, 15)

                ZStack {
                    TextViewRepresentable(value: $field.value)
                        .frame(height: 99)
                        .border(.gray, width: 1.0)
                        .foregroundColor(Color(R.color.colorWhite.name))
                        .padding(.all)
                        .onAppear { self.field.doValidate() }
                }
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

struct TextViewRepresentable: UIViewRepresentable {
    @Binding var value: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.blue.cgColor
        view.textColor = R.color.colorWhite()
        view.font = UIFont.systemFont(ofSize: 18)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = value
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewRepresentable

        init(_ multilineInputCell: TextViewRepresentable) {
            self.parent = multilineInputCell
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.value = textView.text
        }
    }
}
