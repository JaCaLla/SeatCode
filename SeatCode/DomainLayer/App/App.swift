//
//  App.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

struct App {
    var dataManager: DataManagerProtocol
    var dbManager: DBManagerProtocol

    init(dataManager: DataManagerProtocol = DataManager(),
         dbManager: DBManagerProtocol = DBManager()) {
        self.dataManager = dataManager
        self.dbManager = dbManager
    }
}

var currentApp = App()
