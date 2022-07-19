//
//  TripsPresenter.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

protocol TripsPresenterProtocol: AnyObject {
    func set(tripsVC: TripsVCProtocol)
    func fetchTrips() async
}

internal final class TripsPresenter {
 
    // MARK: - Private attributes
    private var interactor: TripsInteractorProtocol
    private weak var view: TripsVCProtocol?
    
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
                let tripsVM: [TripVM] = trips.map({ TripVM(trip: $0)})
                    view?.presentFetchedTrips(tripsVM: tripsVM)
            case .failure(let error):
                view?.present(error: error)
            }
        }
    }
}


