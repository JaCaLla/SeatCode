//
//  IssueView.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import UIKit

enum PersonDetailViewOptions: Int {
    case name
    case surename
    case email
    case phone
    case timestamp
    case report
    case deleteAction

    private static let allValuesEditMode = [name, surename, email, phone, timestamp, report, deleteAction]

    static func count() -> Int {
        return PersonDetailViewOptions.allValuesEditMode.count
    }

    static func get(index: Int) -> PersonDetailViewOptions? {
        guard index < PersonDetailViewOptions.allValuesEditMode.count else { return nil }
        return PersonDetailViewOptions.allValuesEditMode[index]
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   issueVM: IssueVM,
                   personDetailView: IssueView) -> UITableViewCell {
        switch self {
        case .name, .surename, .email, .phone:
            let identifier = R.reuseIdentifier.attributeIssueTVC.identifier
            guard let attributeIssueTVC: AttributeIssueTVC =
                tableView.dequeueReusableCell(withIdentifier: identifier) as? AttributeIssueTVC,
                let attributePersonType = getAttributePersonType(issueVM: issueVM) else { return UITableViewCell() }
            attributeIssueTVC.set(attributePersonType: attributePersonType)
            attributeIssueTVC.onEmailValueChanged = personDetailView.onEmailValueChanged
            attributeIssueTVC.onNameValueChanged = personDetailView.onNameValueChanged
            attributeIssueTVC.onSurenameValueChanged = personDetailView.onSurenameValueChanged
            attributeIssueTVC.onPhoneValueChanged = personDetailView.onPhoneValueChanged
            return attributeIssueTVC
        case .timestamp:
            let idientifier = R.reuseIdentifier.dateSelectorTVC.identifier
            guard let dateSelectorTVC: DateSelectorTVC = tableView.dequeueReusableCell(withIdentifier: idientifier) as? DateSelectorTVC,
                let attributePersonType = getAttributePersonType(issueVM: issueVM) else { return UITableViewCell() }
            dateSelectorTVC.onTimestampValueChanged = personDetailView.onTimestampValueChanged
            dateSelectorTVC.set(attributePersonType: attributePersonType)
            return dateSelectorTVC
        case .report:
            let identifier = R.reuseIdentifier.reportTVC.identifier
            guard let reportTVC: ReportTVC = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReportTVC,
                let attributePersonType = getAttributePersonType(issueVM: issueVM) else { return UITableViewCell() }
            reportTVC.onReportValueChanged = personDetailView.onReportValueChanged
            reportTVC.set(attributePersonType: attributePersonType)
            return reportTVC
        case .deleteAction:
            let identifier = R.reuseIdentifier.actionIssueTVC.identifier
            guard let actionIssueTVC: ActionIssueTVC = tableView.dequeueReusableCell(withIdentifier: identifier) as? ActionIssueTVC else { return UITableViewCell() }
            actionIssueTVC.onSaveAction = {
                personDetailView.onSaveAction()
            }
            return actionIssueTVC
        }
    }

    func getAttributePersonType(issueVM: IssueVM?) -> AttributeIssueType? {
        switch self {
        case .name: return AttributeIssueType.name(issueVM)
        case .surename: return AttributeIssueType.surename(issueVM)
        case .email: return AttributeIssueType.email(issueVM)
        case .phone: return AttributeIssueType.phone(issueVM)
        case .timestamp: return AttributeIssueType.timestamp(issueVM)
        case .report: return AttributeIssueType.report(issueVM)
        case .deleteAction: return nil
        }
    }
}

class IssueView: UITableView {

    // MARK: - Callbacks
    var onEmailValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onNameValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onSurenameValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onPhoneValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onTimestampValueChanged: (Date) -> Void = { _ in /* Default empty block*/ }
    var onReportValueChanged: (String) -> Void = { _ in /* Default empty block*/ }
    var onSaveAction: () -> Void = { /* Default empty block*/ }

    // MARK: - Private attributes
    private var issueVM: IssueVM?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    // MARK: - Public methods
    func set(issueVM: IssueVM?) {
        self.issueVM = issueVM
        self.refreshView()
    }

    // MARK: - Internal/Private
    func setupView() {

        self.dataSource = self
        self.tableFooterView = UIView()
    }

    private func refreshView() {

        self.reloadData()
    }

}

extension IssueView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PersonDetailViewOptions.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let personDetailViewOptions = PersonDetailViewOptions.get(index: indexPath.row),
            let upwIssueVM = self.issueVM else { return UITableViewCell() }

        return personDetailViewOptions.tableView(tableView,
                                                 cellForRowAt: indexPath,
                                                 issueVM: upwIssueVM,
                                                 personDetailView: self)
    }
}
