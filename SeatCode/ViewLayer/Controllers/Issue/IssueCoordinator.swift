//
//  IssueCoordinator.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import Combine
import Foundation
import SwiftUI
import UIKit

internal final class IssueCoordinator {

    // MARK: - Internal/Private attributes
    private var navigationController: UINavigationController = UINavigationController()
    private var issue: Issue = Issue()
    private var onDismissIssueSubscription = Set<AnyCancellable>()

    // MARK: - Public methods
    func start(navigationController: UINavigationController, issue: Issue) {
        self.navigationController = navigationController
        self.issue = issue

        let alert = UIAlertController(title: R.string.localizable.issue_coordinator_alert_title.key.localized,
                                      message: R.string.localizable.issue_coordinator_alert_message.key.localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "UIKit", style: .default, handler: { [weak self] _ in
            self?.presentIssue(isUIKit: true)
        }))
        alert.addAction(UIAlertAction(title: "SwiftUI", style: .default, handler: { [weak self] _ in
            self?.presentIssue(isUIKit: false)
        }))
        navigationController.present(alert, animated: true, completion: nil)
    }

    // MARK: - Private/Internal methods
    private func presentIssue(isUIKit: Bool) {

        if isUIKit {
            let interactor = IssueInteractor(issue: issue)
            let presenter = IssuePresenter(interactor: interactor)
            let issueVC = IssueVC.instantiate(presenter: presenter)
            issueVC.onDismiss = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            navigationController.pushViewController(issueVC, animated: true)
        } else {
            let interactor = FormInteractor(issue: issue)
            let presenter = FormPresenter(interactor: interactor)
            let formView = FormView(presenter: presenter)
            presenter.set(view: formView)
            let formVC = UIHostingController(rootView: formView)
            formView.onDismissPublisher.sink {
                self.navigationController.popViewController(animated: true)
            }
            .store(in: &onDismissIssueSubscription)
            navigationController.pushViewController(formVC, animated: true)
        }
    }

}
