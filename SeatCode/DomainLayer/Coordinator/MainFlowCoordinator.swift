//
//  MainFlowCoordinator.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class MainFlowCoordinator {

    // MARK: - Singleton handler
    static let shared = MainFlowCoordinator()

    // MARK: - Private attributes
    private let navigationController = UINavigationController()
    private var onGetIssueSubscription = Set<AnyCancellable>()
    private var onDismissIssueSubscription = Set<AnyCancellable>()

    private init() { /*This prevents others from using the default '()' initializer for this class. */ }

    // MARK: - Pulic methods
    func start() {
        return self.presentTransactionsList()
    }

    // MARK: - Private/Internal
    private func presentTransactionsList() {

        let tripsVC = TripsVC.instantiate()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        navigationController.viewControllers = [tripsVC]
        window.rootViewController = navigationController
    }
}
