//
//  IssueInteractor.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import Foundation
import UIKit

protocol IssueInteractorProtocol: AnyObject {
    func getIssue() -> IssueVM
    func onNameValueChanged(value: String)
    func onSurenameValueChanged(value: String)
    func onEmailValueChanged(value: String)
    func onTimestampValueChanged(value: Date)
    func onReportValueChanged(value: String)
    func onPhoneValueChanged(value: String)
    func saveIssue() async
}

internal final class IssueInteractor {

    // MARK: - Internal/Private attributes
    var issue: Issue

    // MARK: - Initializer constructor
    init(issue: Issue) {
        self.issue = issue
    }
}

// MARK: - IssueInteractorProtocol
extension IssueInteractor: IssueInteractorProtocol {
    func getIssue() -> IssueVM {
        return IssueVM(issue: issue)
    }

    func onNameValueChanged(value: String) {
        issue.name = value
    }

    func onSurenameValueChanged(value: String) {
        issue.surename = value
    }

    func onEmailValueChanged(value: String) {
        issue.email = value
    }

    func onTimestampValueChanged(value: Date) {
        issue.timestamp = value.timeIntervalSince1970
    }

    func onReportValueChanged(value: String) {
        issue.report = value
    }

    func onPhoneValueChanged(value: String) {
        issue.phone = value
    }

    func saveIssue() async {
        await currentApp.dataManager.create(issue: issue)
        Task { @MainActor in
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: .badge)
                UIApplication.shared.applicationIconBadgeNumber = currentApp.dataManager.getIssuesCount()
            } catch {

            }
        }
    }
}
