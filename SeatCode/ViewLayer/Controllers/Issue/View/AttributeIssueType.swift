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
        case .name: return R.string.localizable.issue_name.key.localized
        case .surename: return R.string.localizable.issue_surename.key.localized
        case .email: return R.string.localizable.issue_email.key.localized
        case .phone: return R.string.localizable.issue_phone.key.localized
        case .timestamp: return R.string.localizable.issue_timestamp.key.localized
        case .report: return R.string.localizable.issue_report.key.localized
        }
    }

    func getValue() -> String {
        switch self {
        case .name(let issueVM): return issueVM?.name ?? ""
        case .surename(let issueVM): return issueVM?.surename ?? ""
        case .email(let issueVM): return issueVM?.email ?? ""
        case .phone(let issueVM): return issueVM?.phone ?? ""
        case .timestamp: return ""
        case .report(let issueVM): return issueVM?.report ?? ""
        }
    }

    func onValueChanged(attributePersonTVC: AttributeIssueTVC, value: String) {
        switch self {
        case .name: attributePersonTVC.onNameValueChanged(value)
        case .surename: attributePersonTVC.onSurenameValueChanged(value)
        case .email: attributePersonTVC.onEmailValueChanged(value)
        case .phone: attributePersonTVC.onPhoneValueChanged(value)
        case .timestamp, .report: return
        }
    }

    func onValueChanged(reportTVC: ReportTVC, value: String) {
        switch self {
        case .name: return
        case .surename: return
        case .email: return
        case .phone: return
        case .timestamp: return
        case .report: reportTVC.onReportValueChanged(value)

        }
    }

    func getDate() -> Date? {
        switch self {
        case .name, .surename, .email, .report, .phone: return nil
        case .timestamp(let issueVM): return issueVM?.timestamp
        }
    }
}
