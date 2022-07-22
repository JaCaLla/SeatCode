//
//  TripListCell.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import UIKit

class TripListCell: UITableViewCell {

    // MARK: - @IBOutlet
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblStartEnd: UILabel!
    @IBOutlet weak var lblOriginDestination: UILabel!
    @IBOutlet weak var disclosureImage: UIImageView!

    // MARK: - Callbacks
    var onGetIssue: () -> Void = { /* Default empty block */ }

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
        
        disclosureImage.image = tripVM.hasIssue ? UIImage(systemName: "text.badge.xmark") : UIImage(systemName: "checkmark.circle")
        disclosureImage.tintColor = tripVM.hasIssue ? AppColors.Trip.issueFoundColor : AppColors.Trip.issueNotFoundColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        disclosureImage.addGestureRecognizer(tap)
        disclosureImage.isUserInteractionEnabled = true
    }
    
    // MARK : - Target methods
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        onGetIssue()
    }
}
