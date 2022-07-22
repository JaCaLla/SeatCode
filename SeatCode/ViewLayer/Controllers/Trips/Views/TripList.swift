//
//  TripList.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import UIKit

class TripList: UITableView {
    
    // MARK: - Callbacks
    var onSelect: (TripVM) -> Void = { _ in /* Default empty block */}
    var onGetIssue: (TripVM) -> Void = { _ in /* Default empty block */ }
    
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
        delegate = self
        self.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension TripList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tripsVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let tripListCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.routeListCell.identifier, for: indexPath) as? TripListCell else {
            return UITableViewCell()
        }
        tripListCell.set(tripVM: self.tripsVM[indexPath.row])
        tripListCell.onGetIssue = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.onGetIssue(weakSelf.tripsVM[indexPath.row])
        }
        return tripListCell
    }
}

// MARK: - UITableViewDelegate
extension TripList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSelect(self.tripsVM[indexPath.row])
    }
}
