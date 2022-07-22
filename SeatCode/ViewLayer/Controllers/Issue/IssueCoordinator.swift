//
//  IssueCoordinator.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import Foundation
import UIKit

internal final class IssueCoordinator {
    
    //MARK: - Internal/Private attributes
    var navigationController: UINavigationController = UINavigationController()
    var issue: Issue = Issue()
    
    
    // MARK: - Public methods
    func start(navigationController: UINavigationController, issue: Issue) {
        self.navigationController = navigationController
        self.issue = issue
        presentIssue()
    }
    
    // MARKI: - Private/Internal methods
    private func presentIssue() {
        
         let interactor = IssueInteractor(issue: issue)
        let presenter = IssuePresenter(interactor: interactor)
        let issueVC = IssueVC.instantiate(presenter: presenter)
        issueVC.onDismiss = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(issueVC, animated: true)
    }
    
}
