//
//  AttributeIssueTVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import UIKit

class AttributeIssueTVC: UITableViewCell {

    // MARKK : - IBOutlets
    @IBOutlet weak var txtAttributeValue: UITextField!
    @IBOutlet weak var lblAttributeName: UILabel!

    // MARK: - Callbacks
    var onEmailValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onNameValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onSurenameValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onPhoneValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    
    private var attributePersonType: AttributeIssueType?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Public methods
    func set(attributePersonType: AttributeIssueType) {

        self.attributePersonType = attributePersonType
        self.refreshView()
    }

    // MARK: - Target methods
    @objc func textFieldDidChange(textField: UITextField) {

        guard let text = textField.text else { return }
        textField.text = text
        attributePersonType?.onValueChanged(attributePersonTVC: self, value: text)

    }

    //  MARK: - Private/Internal methods
    private func setupView() {
        self.selectionStyle = .none
        txtAttributeValue.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtAttributeValue.delegate = self
    }

    private func refreshView() {
        lblAttributeName.textColor = AppColors.PersonDetail.fontColor
        lblAttributeName.text = attributePersonType?.getText()

        txtAttributeValue.text = attributePersonType?.getValue()
    }
}

extension AttributeIssueTVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
            let uwpAttributePersonType = attributePersonType else { return }
        uwpAttributePersonType.onValueChanged(attributePersonTVC: self, value: text)
        self.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let text = textField.text,
            let uwpAttributePersonType = attributePersonType else { return false }
        uwpAttributePersonType.onValueChanged(attributePersonTVC: self, value: text)
        self.endEditing(true)
        return false
    }
}
