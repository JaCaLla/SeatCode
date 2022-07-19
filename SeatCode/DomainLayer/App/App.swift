//
//  App.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

struct App {
    var dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
}

var currentApp = App()
