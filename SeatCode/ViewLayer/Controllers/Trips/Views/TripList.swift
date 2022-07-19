//
//  TripList.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import UIKit

class TripList: UITableView {
    
    // MARK: - Callbacks
    
    // MARK: - Private attributes
    private var tripsVM:[TripVM] = []

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
   // MARK: - Public methods
    func set(tripsVM: [TripVM]) {
        self.tripsVM = tripsVM
        self.reloadData()
    }

    // MARK: - Private methdos
    func setupView() {
        dataSource = self
        self.tableFooterView = UIView()
    }
}

extension TripList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tripsVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let routeListCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.routeListCell.identifier, for: indexPath) as? TripListCell else {
            return UITableViewCell()
        }
        routeListCell.set(routeVM: self.tripsVM[indexPath.row])
        return routeListCell
    }
}
