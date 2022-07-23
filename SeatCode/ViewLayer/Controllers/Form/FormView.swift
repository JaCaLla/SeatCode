//
//  FormView.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import Combine
import SwiftUI

protocol FormViewProtocol {
    func presentActivityIndicator()
    func removeActivityIndicator()
    func dismiss()
}

struct FormView: View {

    // MARK: - Callbacks
    var onDismissPublisher: AnyPublisher<Void, Never> {
        return onDismissInternalPublisher.eraseToAnyPublisher()
    }
    public var onDismissInternalPublisher = PassthroughSubject<Void, Never>()

    // MARK: - @ObservedObject
    @ObservedObject var keyboardHandler: KeyboardFollower = KeyboardFollower()

    // MARK: - @State
    @State var isWrongFilled: Bool = false
    @State var isShareSheetPresented: Bool = false
    @State var issueUI: IssueUI = IssueUI()

    // MARK: - Private/Internal attributes
    private var presenter: FormPresenterProtocol

    // MARK: - Initializer/Constructor
    init(presenter: FormPresenterProtocol,
         keyboardHandler: KeyboardFollower = KeyboardFollower()) {
        self.presenter = presenter
        self.keyboardHandler = keyboardHandler
    }

    // MARK: - Field Checkers
    let notEmptyValidator: (String) -> (String?) = { value in
        guard !value.isEmpty else { return R.string.localizable.issue_error_empty.key.localized }
        return nil
    }
    @State var isNameValid = FieldChecker()
    @State var isSurenameValid = FieldChecker()
    let emailValidator: (String) -> (String?) = { value in

        let emailPred = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPred.evaluate(with: value) ? nil : R.string.localizable.issue_error_email.key.localized
    }
    @State var isEmailValid = FieldChecker()
    let phoneValidator: (String) -> (String?) = { value in
        var validPhoneNumber = false
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else {
            return R.string.localizable.issue_error_phone.key.localized
        }
        if let match = detector.matches(in: value, options: [], range: NSMakeRange(0, value.count)).first?.phoneNumber,
            match == value {
            validPhoneNumber = true
        }
        return validPhoneNumber ? nil : R.string.localizable.issue_error_phone.key.localized
    }
    @State var isPhoneValid = FieldChecker()

    let timestampValidator: (Date) -> (String?) = { _ in
        return nil
    }
    @State var isTimestampValid = FieldChecker()

    let reportValidator: (String) -> (String?) = { value in
        guard value.count < 200 else { return R.string.localizable.issue_error_report.key.localized }
        return nil
    }
    @State var isReportValid = FieldChecker()

    @State var saveButtonEnabled = false

    // MARK: - body
    var body: some View {
        ScrollView {
            VStack {
                TextInputCell(title: R.string.localizable.issue_name.key.localized,
                              value: $issueUI.name.self,
                              checker: $isNameValid,
                              validator: notEmptyValidator)
                    .autocapitalization(.none)
                TextInputCell(title: R.string.localizable.issue_surename.key.localized,
                              value: $issueUI.surename.self,
                              checker: $isSurenameValid,
                              validator: notEmptyValidator)
                    .autocapitalization(.none)

                TextInputCell(title: R.string.localizable.issue_email.key.localized,
                              value: $issueUI.email.self,
                              checker: $isEmailValid,
                              validator: emailValidator)
                    .autocapitalization(.none)

                TextInputCell(title: R.string.localizable.issue_phone.key.localized,
                              value: $issueUI.phone.self,
                              checker: $isPhoneValid,
                              validator: phoneValidator)
                    .autocapitalization(.none)

                DateInputCell(title: R.string.localizable.issue_timestamp.key.localized,
                              value: $issueUI.timestamp.self,
                              checker: $isTimestampValid,
                              validator: timestampValidator)
                    .autocapitalization(.none)

                MultilineInputCell(title: R.string.localizable.issue_report.key.localized,
                                   value: $issueUI.report.self,
                                   checker: $isReportValid,
                                   validator: reportValidator)

                ActionCell(isEnabled: isFormProperlyFilled()) {
                    guard self.isFormProperlyFilled() else { return }
                    Task {
                        await self.presenter.save(issueUI: issueUI)
                    }
                }
                Spacer()
            }.padding(.bottom, keyboardHandler.keyboardHeight)
        }.onAppear {
            issueUI = presenter.getIssue()
        }.navigationTitle(R.string.localizable.issue_title.key.localized)
    }

    // MARK: - Private methods
    private func isFormProperlyFilled() -> Bool {
        return isNameValid.valid &&
            isSurenameValid.valid &&
            isEmailValid.valid &&
            isPhoneValid.valid &&
            isReportValid.valid
    }
}

// MARK: - FormViewProtocol
extension FormView: FormViewProtocol {
    func presentActivityIndicator() {
        isShareSheetPresented.toggle()
    }

    func removeActivityIndicator() {
        isShareSheetPresented.toggle()
    }

    func dismiss() {
        self.onDismissInternalPublisher.send()
    }
}
