//
//  DateSelectorTVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import UIKit

class DateSelectorTVC: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var attributeNameLabel: UILabel!
    @IBOutlet weak var timeStampPicker: UIDatePicker!

    // MARK: - Callbacks
    var onTimestampValueChanged: (Date) -> Void = { _ in /* Default empty block*/ }

    // MARK: - Private attributes
    private var attributePersonType: AttributeIssueType?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - public methods
    func set(attributePersonType: AttributeIssueType) {

        self.attributePersonType = attributePersonType
        self.refreshView()
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        self.onTimestampValueChanged(picker.date)
    }

    //  MARK: - Private/Internal methods
    private func setupView() {
        self.selectionStyle = .none
        timeStampPicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)

    }

    private func refreshView() {
        attributeNameLabel.text = attributePersonType?.getText()
        if let date = attributePersonType?.getDate() {
            timeStampPicker.date = date
        }
    }

}
