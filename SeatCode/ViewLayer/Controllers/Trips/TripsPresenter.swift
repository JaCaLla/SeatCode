//
//  TripsPresenter.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//
import Foundation

protocol TripsPresenterProtocol: AnyObject {
    func set(tripsVC: TripsVCProtocol)
    func fetchTrips() async
    func fetchIssue(endTime: String) async
    func fetchStops(tripVM: TripVM) async
}

internal final class TripsPresenter {
 
    // MARK: - Private attributes
    private var interactor: TripsInteractorProtocol
    private weak var view: TripsVCProtocol?
    private var trips: [Trip]?
    
    // MARK: - Constructor/Initializer
    init(interactor: TripsInteractorProtocol = TripsInteractor()) {
        self.interactor = interactor
    }
}

// MARK: - TripsPresenterProtocol
extension TripsPresenter: TripsPresenterProtocol {
    
    func set(tripsVC: TripsVCProtocol) {
        self.view = tripsVC
    }
    
    func fetchTrips() async {
        Task { @MainActor in
            view?.presentActivityIndicator()
        }
        let result = await interactor.fetchTrips()
        Task { @MainActor in
           view?.removeActivityIndicator()
            switch result {
            case .success(let trips):
                self.trips = trips
                let tripsVM: [TripVM] = trips.map({ TripVM(trip: $0)})
                    view?.presentFetchedTrips(tripsVM: tripsVM)
            case .failure:
                view?.presentAlertError(message: R.string.localizable.trips_alert_message_trips.key.localized)
            }
        }
    }
    
    func fetchStops(tripVM: TripVM) async {
        guard let trips = trips,
            let index = trips.firstIndex(where: { $0.endTime == tripVM.endTime }) else { return }
        Task { @MainActor in
            view?.presentActivityIndicator()
        }
        Task { @MainActor in
            let result = await interactor.fetchStops(trip: trips[index])
            view?.removeActivityIndicator()
            switch result {
            case .success(let trip):
                let tripVM = TripVM(trip: trip)
                view?.presentStopPoints(tripVM: tripVM)
            case .failure:
                view?.presentAlertError(message: R.string.localizable.trips_alert_message_stops.key.localized)
            }
        }
    }
    
    func fetchIssue(endTime: String) async {
        view?.presentActivityIndicator()
        let issue = await interactor.getIssue(endTime: endTime)
        view?.removeActivityIndicator()
        let uwpIssue = Issue(route: issue?.route ?? "",
                             name: issue?.name ?? "",
                                             surename: issue?.surename ?? "",
                                             email: issue?.email ?? "",
                                             timestamp: issue?.timestamp ?? -1,
                                             report: issue?.report ?? "",
                                             phone: issue?.phone ?? "",
                             endTime: endTime)
        view?.onGetIssue(issue: uwpIssue)
    }
}


