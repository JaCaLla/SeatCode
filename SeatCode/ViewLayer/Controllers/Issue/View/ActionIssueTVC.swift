//
//  ActionIssueTVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import UIKit

enum ActionPersonType {
    case delete
    func getText() -> String {
        switch self {
        case .delete: return R.string.localizable.issue_save.key.localized
        }
    }
}

class ActionIssueTVC: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Callbacks
    var onSaveAction: () -> Void = { /* Default empty block */ }

    // MARK: - Public attributes
    var actionPersonType: ActionPersonType = .delete {
        didSet {
            setupView()
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    // MARK: - Internal/Private
    func setupView() {

        self.backgroundColor = R.color.colorWhite()
        self.selectionStyle = .none

        saveButton.titleLabel?.textColor = R.color.colorBlack()
        saveButton.backgroundColor = R.color.colorRed()
        saveButton.setTitle(actionPersonType.getText(), for: .normal)
        saveButton.layer.cornerRadius = 5.0

        saveButton.addTarget(self, action: #selector(onActionButton), for: .touchUpInside)
    }

    // MARK: - Target methods
    @objc func onActionButton(sender: UIButton!) {
        switch actionPersonType {
        case .delete: self.onSaveAction()
        }
    }
}
