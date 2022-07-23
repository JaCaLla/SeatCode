//
//  FormInteractor.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import Combine
import Foundation
import SwiftUI
import UIKit

protocol FormInteractorProtocol: AnyObject {
    func getIssue() -> IssueUI
    func saveIssue(issueUI: IssueUI) async
}

internal final class FormInteractor {

    // MARK: - Internal/Private attributes
    var issue: Issue

    // MARK: - Initializer constructor
    init(issue: Issue) {
        self.issue = issue
    }
}

// MARK: - FormInteractorProtocol
extension FormInteractor: FormInteractorProtocol {

    func getIssue() -> IssueUI {
        let issueUI = IssueUI(issue: issue)
        return issueUI
    }

    func saveIssue(issueUI: IssueUI) async {
        let issue = Issue(issueUI: issueUI)
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
