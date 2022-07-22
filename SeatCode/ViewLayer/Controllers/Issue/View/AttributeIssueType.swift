//
//  AttributeIssueType.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import Foundation

enum AttributeIssueType {
    case name(IssueVM?)
    case surename(IssueVM?)
    case email(IssueVM?)
    case phone(IssueVM?)
    case timestamp(IssueVM?)
    case report(IssueVM?)

    func getText() -> String {
        switch self {
        case .name(_): return R.string.localizable.issue_name.key.localized
        case .surename(_): return R.string.localizable.issue_surename.key.localized
        case .email(_): return R.string.localizable.issue_email.key.localized
        case .phone(_): return R.string.localizable.issue_phone.key.localized
        case .timestamp(_): return R.string.localizable.issue_timestamp.key.localized
        case .report(_): return R.string.localizable.issue_report.key.localized
        }
    }

    func getValue() -> String {
        switch self {
        case .name(let issueVM): return issueVM?.name ?? ""
        case .surename(let issueVM): return issueVM?.surename ?? ""
        case .email(let issueVM): return issueVM?.email ?? ""
        case .phone(let issueVM): return issueVM?.phone ?? ""
        case .timestamp(_): return ""
        case .report(let issueVM): return issueVM?.report ?? ""
        }
    }

    func onValueChanged(attributePersonTVC: AttributeIssueTVC, value: String) {
        switch self {
        case .name(_): attributePersonTVC.onNameValueChanged(value)
        case .surename(_): attributePersonTVC.onSurenameValueChanged(value)
        case .email(_): attributePersonTVC.onEmailValueChanged(value)
        case .phone(_): attributePersonTVC.onPhoneValueChanged(value)
        case .timestamp(_), .report(_): return
        }
    }

    func onValueChanged(reportTVC: ReportTVC, value: String) {
        switch self {
        case .name(_): return
        case .surename(_): return
        case .email(_): return
        case .phone(_): return
        case .timestamp(_): return
        case .report(_): reportTVC.onReportValueChanged(value)

        }
    }

    func getDate() -> Date? {
        switch self {
        case .name(_), .surename(_), .email(_), .report(_), .phone(_): return nil
        case .timestamp(let issueVM): return issueVM?.timestamp
        }
    }
}
