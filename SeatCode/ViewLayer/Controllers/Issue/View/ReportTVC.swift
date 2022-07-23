//
//  ReportTVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//
import UIKit

class ReportTVC: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var attributeNameLabel: UILabel!
    @IBOutlet weak var reportTextView: UITextView!

    // MARK: - Callbacks
    var onReportValueChanged: (String) -> Void = { _ in /* Default empty block*/ }

    // MARK: - Private attributes
    private var attributePersonType: AttributeIssueType?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupView()
    }

    // MARK: - Public methods
    func set(attributePersonType: AttributeIssueType) {

        self.attributePersonType = attributePersonType
        self.refreshView()
    }

    // MARK: - Private/Internal methods
    private func setupView() {
        self.selectionStyle = .none
        self.reportTextView.delegate = self
    }

    private func refreshView() {
        attributeNameLabel.text = attributePersonType?.getText()
        reportTextView.text = attributePersonType?.getValue()
    }
}

extension ReportTVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text,
            let uwpAttributePersonType = attributePersonType else { return }
        uwpAttributePersonType.onValueChanged(reportTVC: self, value: text)
    }

}
