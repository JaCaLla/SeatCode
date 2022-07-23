//
//  TripsVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import JGProgressHUD
import UIKit

protocol TripsVCProtocol: AnyObject {
    func presentActivityIndicator()
    func removeActivityIndicator()
    func presentAlertError(message: String)
    func presentFetchedTrips(tripsVM: [TripVM])
    func presentStopPoints(tripVM: TripVM)
    func onGetIssue(issue: Issue)
}

class TripsVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tripList: TripList!
    @IBOutlet weak var tripMap: TripMap!

    // MARK: - Callback
    var onGetIssue: (Issue) -> Void = { _ in /* Default empty block */ }

    // MARK: - Private attributes
    private let hud = JGProgressHUD()
    private var presenter: TripsPresenterProtocol = TripsPresenter()

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

        tripList.onSelect = { [weak self] tripVM in
            Task {
                await self?.presenter.fetchStops(tripVM: tripVM)
            }
        }
        tripList.onGetIssue = { [weak self] tripVM in
            Task {
                await self?.presenter.fetchIssue(endTime: tripVM.endTime)
            }
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

    func presentAlertError(message: String) {
        let alert = UIAlertController(title: R.string.localizable.issue_alert_title.key.localized,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.alert_continue.key.localized,
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func presentFetchedTrips(tripsVM: [TripVM]) {
        tripList.set(tripsVM: tripsVM)
    }

    func presentStopPoints(tripVM: TripVM) {
        tripMap.set(tripVM: tripVM)
    }

    func onGetIssue(issue: Issue) {
        onGetIssue(issue)
    }
}
