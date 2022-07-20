//
//  TripListCell.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import UIKit

class TripListCell: UITableViewCell {

    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblStartEnd: UILabel!
    @IBOutlet weak var lblOriginDestination: UILabel!


    // MARK: - Callbacks

    // MARK: - Private attributes
    private var tripVM: TripVM?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - Public methods
    func set(tripVM: TripVM) {
        self.tripVM = tripVM
        lblOriginDestination.text = tripVM.originDestination
        lblStartEnd.text = tripVM.startEnd
        lblDriverName.text = tripVM.driverName
    }
}
