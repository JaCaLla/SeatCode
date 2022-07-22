//
//  DBManager.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation
import RealmSwift


protocol Resetable: AnyObject {
    func reset()
}
protocol DBManagerProtocol: Resetable {
    func create(issueDB: IssueDB) async
    func getIssues() -> Results<IssueDB>
    func getIssues() async -> Results<IssueDB>
    func getIssue(endTime: String) async -> IssueDB?
    func getIssue(endTime: String) -> IssueDB?
    func reset()
}



// MARK: - Resetable
class DBManager {

    var thread = Thread.current
    var realm: Realm!

    init() {
        setRealmHandlers()
    }
}

extension DBManager: DBManagerProtocol {

    // MARK: - IssueDB
    func create(issueDB: IssueDB) async {
        self.resetHandlerIfNecessary()
        if let foundIssueDB = await self.getIssue(endTime: issueDB.endTime) {
            await self.rename(issueDB: foundIssueDB, newIssueDB: issueDB)
        } else {
            do {
                try realm.write({
                    self.realm.add(issueDB)
                    return
                })
            } catch {
                // handle error
                // TO DO!!!
            }
        }
    }

    func getIssues() -> Results<IssueDB> {

        self.resetHandlerIfNecessary()
        return realm.objects(IssueDB.self)
    }

    func getIssues() async -> Results<IssueDB> {

        self.resetHandlerIfNecessary()
        return realm.objects(IssueDB.self)
    }

    func getIssue(endTime: String) -> IssueDB? {

        self.resetHandlerIfNecessary()
        guard let uwpFoundMachine = realm.objects(IssueDB.self).filter("endTime = %@", endTime).first else {
            return nil
        }

        return uwpFoundMachine
    }

    func getIssue(endTime: String) async -> IssueDB? {
        self.resetHandlerIfNecessary()
        guard let uwpFoundMachine = realm.objects(IssueDB.self).filter("endTime = %@", endTime).first else {
            return nil
        }

        return uwpFoundMachine
    }

    func reset() {

        self.resetHandlerIfNecessary()
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            // handle error
            // TO DO!!
        }
    }

    // MARK: - Private/Internal

    func rename(issueDB: IssueDB, newIssueDB: IssueDB, onComplete: @escaping () -> Void) {
        self.resetHandlerIfNecessary()
        guard !(realm.objects(IssueDB.self).isEmpty) else { return }
        do {
            try realm.write({
                issueDB.route = newIssueDB.route
                issueDB.surename = newIssueDB.surename
                issueDB.email = newIssueDB.email
                issueDB.timestamp = newIssueDB.timestamp
                issueDB.report = newIssueDB.report
                issueDB.phone = newIssueDB.phone
                issueDB.name = newIssueDB.name
                onComplete()
            })
        } catch {
            // handle error
            onComplete()
        }
    }

    func rename(issueDB: IssueDB, newIssueDB: IssueDB) async {
        self.resetHandlerIfNecessary()
        guard !(realm.objects(IssueDB.self).isEmpty) else { return }
        do {
            try realm.write({
                issueDB.route = newIssueDB.route
                issueDB.surename = newIssueDB.surename
                issueDB.email = newIssueDB.email
                issueDB.timestamp = newIssueDB.timestamp
                issueDB.report = newIssueDB.report
                issueDB.phone = newIssueDB.phone
                issueDB.name = newIssueDB.name
                return
            })
        } catch {
            // handle error
            return
        }
    }

    func resetHandlerIfNecessary() {
        guard thread == Thread.current else {
            self.setRealmHandlers()
            thread = Thread.current
            return
        }
    }

    func setRealmHandlers() {
        do {
            if NSClassFromString("XCTest") != nil {
                realm = try Realm(configuration: RealmConfig.utest.configuration)
            } else {
                realm = try Realm(configuration: RealmConfig.main.configuration)
            }
        } catch {
            // handle error
            print("REALM ERROR: MIGRATION TO SECURED DDBB WAS NOT POSSIBLE!!!!")
        }
    }

}
