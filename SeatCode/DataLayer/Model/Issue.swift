//
//  Issue.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation

struct Issue {
    var route: String = ""
    var name: String = ""
    var surename: String = ""
    var email: String = ""
    var timestamp: Double = -1.0
    var report: String = ""
    var phone: String = ""
    var endTime: String = ""

    // MARK: - Constructor/Initializers
    init() {
    }

    init(route: String,
         name: String,
         surename: String,
         email: String,
         timestamp: Double,
         report: String,
         phone: String,
         endTime: String) {
        self.route = route
        self.name = name
        self.surename = surename
        self.email = email
        self.timestamp = timestamp
        self.report = report
        self.phone = phone
        self.endTime = endTime
    }

    init(issueDB: IssueDB) {
        self.init(route: issueDB.route,
                  name: issueDB.name,
                  surename: issueDB.surename,
                  email: issueDB.email,
                  timestamp: issueDB.timestamp,
                  report: issueDB.report,
                  phone: issueDB.phone,
                  endTime: issueDB.endTime)
    }

    init(issueUI: IssueUI) {
        self.init(route: issueUI.route,
                  name: issueUI.name,
                  surename: issueUI.surename,
                  email: issueUI.email,
                  timestamp: issueUI.timestamp.timeIntervalSince1970,
                  report: issueUI.report,
                  phone: issueUI.phone,
                  endTime: issueUI.endTime)
    }
}
