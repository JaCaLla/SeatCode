//
//  TripsVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import UIKit
import JGProgressHUD

protocol TripsVCProtocol: AnyObject {
    func presentActivityIndicator()
    func removeActivityIndicator()
    func present(error: Error)
    func presentFetchedTrips(tripsVM: [TripVM])
}

class TripsVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var routeList: TripList!
    @IBOutlet weak var tripMap: TripMap!


    // MARK: - Private attributes
    let hud = JGProgressHUD()
    var presenter: TripsPresenterProtocol = TripsPresenter()

    // MARK: - Constructor/Initializer
    public static func instantiate(presenter: TripsPresenterProtocol = TripsPresenter()) -> TripsVC {
        let storyboard = UIStoryboard(name: R.storyboard.main.name, bundle: nil)
        guard let tripsVC = storyboard.instantiateViewController(withIdentifier: String(describing: TripsVC.self)) as? TripsVC else {
            return TripsVC()
        }
        tripsVC.presenter = presenter
        presenter.set(tripsVC: tripsVC)
        return tripsVC
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await presenter.fetchTrips()
        }
    }

    // MARK: - Private methods
    func setupViewController() {
        title = R.string.localizable.trips_title.key.localized 
        hud.textLabel.text = R.string.localizable.trips_loading.key.localized
        
        routeList.onSelect = { [weak self] tripVM in
            self?.tripMap.set(tripVM: tripVM)
        }
    }
}

// MARK: - TripsVCProtocol
extension TripsVC: TripsVCProtocol {

    func presentActivityIndicator() {
        hud.show(in: self.view)
    }

    func removeActivityIndicator() {
        hud.dismiss(animated: true)
    }

    func present(error: Error) {
        // TODO
    }

    func presentFetchedTrips(tripsVM: [TripVM]) {
        routeList.set(tripsVM: tripsVM)
    }
}
