//
//  IssuePresenterNew.swift
//  SeatCode
//
//  Created by Javier Calatrava on 22/7/22.
//

import Foundation
import SwiftUI

protocol FormPresenterProtocol {
    func set(view: FormViewProtocol)
    func save(issueUI: IssueUI) async
    func getIssue() -> IssueUI
}

class FormPresenter {
    // MARK: - Private attributes
    private var interactor: FormInteractorProtocol
    private var view: FormViewProtocol? // Look out! strong reference

    // MARK: - Initializer/Constructor
    init(interactor: FormInteractorProtocol) {
        self.interactor = interactor
    }
}

// MARK: - IssuePresenterProtocol
extension FormPresenter: FormPresenterProtocol {
    func save(issueUI: IssueUI) async {
        await interactor.saveIssue(issueUI: issueUI)
        self.view?.dismiss()
    }

    func set(view: FormViewProtocol) {
        self.view = view
    }

    func getIssue() -> IssueUI {
        interactor.getIssue()
    }
}
