//
//  IssuePresenter.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import Foundation

protocol IssuePresenterProtocol: AnyObject {
    func set(issueVC: IssueVCProtocol)
    func getIssue() -> IssueVM
    func onNameValueChanged(value: String)
    func onSurenameValueChanged(value: String)
    func onEmailValueChanged(value: String)
    func onTimestampValueChanged(value: Date)
    func onReportValueChanged(value: String)
    func onPhoneValueChanged(value: String)
    func isProperlyFilled() -> Bool
    func onSaveAction() async
}

internal final class IssuePresenter {

    // MARK: - Internal/Private attributes
    private var interactor: IssueInteractorProtocol
    private weak var view: IssueVCProtocol?

    // MARK: - Initializer constructor
    init(interactor: IssueInteractorProtocol) {
        self.interactor = interactor
    }
}

// MARK: - IssuePresenterProtocol
extension IssuePresenter: IssuePresenterProtocol {

    func set(issueVC: IssueVCProtocol) {
        self.view = issueVC
    }

    func getIssue() -> IssueVM {
        interactor.getIssue()
    }

    func onNameValueChanged(value: String) {
        interactor.onNameValueChanged(value: value)
        //    view?.refreshView(issueVM: getIssue())
    }

    func onSurenameValueChanged(value: String) {
        interactor.onSurenameValueChanged(value: value)
        //     view?.refreshView(issueVM: getIssue())
    }

    func onEmailValueChanged(value: String) {
        interactor.onEmailValueChanged(value: value)
        // view?.refreshView(issueVM: getIssue())
    }

    func onTimestampValueChanged(value: Date) {
        interactor.onTimestampValueChanged(value: value)
        //      view?.refreshView(issueVM: getIssue())
    }

    func onReportValueChanged(value: String) {
        interactor.onReportValueChanged(value: value)
        //    view?.refreshView(issueVM: getIssue())
    }

    func onPhoneValueChanged(value: String) {
        interactor.onPhoneValueChanged(value: value)
        //  view?.refreshView(issueVM: getIssue())
    }

    func isProperlyFilled() -> Bool {
        let issueVM = interactor.getIssue()
        guard issueVM.report.isEmpty || issueVM.report.count <= 200 else { return false }
        guard isValidEmail(issueVM.email) else { return false }

        return !issueVM.name.isEmpty && !issueVM.surename.isEmpty && !issueVM.email.isEmpty
    }

    func onSaveAction() async {
        guard isProperlyFilled() else {
            view?.presentAlertFormNotProperyFullfilled()
            return
        }
        view?.presentActivityIndicator()
        await interactor.saveIssue()
        view?.removeActivityIndicator()
        view?.dismiss()
    }

    // MARK: - Private/Internal methods
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
