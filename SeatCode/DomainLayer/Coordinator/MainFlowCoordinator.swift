//
//  MainFlowCoordinator.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Combine
import Foundation
import SwiftUI
import UIKit

class MainFlowCoordinator {

    // MARK: - Singleton handler
    static let shared = MainFlowCoordinator()

    // MARK: - Private attributes
    private let navigationController = UINavigationController()
    private let issueCoordinator = IssueCoordinator()

    private init() { /*This prevents others from using the default '()' initializer for this class. */ }

    // MARK: - Pulic methods
    func start() {
        return self.presentTransactionsList()
    }

    // MARK: - Private/Internal
    private func presentTransactionsList() {

        let tripsVC = TripsVC.instantiate()
        tripsVC.onGetIssue = { [weak self] issue in
            guard let navigationController = tripsVC.navigationController else { return }
            self?.issueCoordinator.start(navigationController: navigationController,
                                     issue: issue)
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else { return }
        navigationController.viewControllers = [tripsVC]
        window.rootViewController = navigationController
    }
}
