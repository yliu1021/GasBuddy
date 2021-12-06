//
//  GasTripViewModel.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import Combine
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

enum LocationStatus: Equatable {
  case notAuthorized  // user disallowed location services
  case idle  // not doing anything (when view is first instantiated)
  case locating  // still locating user
  // located but haven't reverse geocoded yet
  case locatedNoAddress(CLLocation)
  // located and found gas station + address
  case locatedWithAddess(CLLocation, station: String, address: String)
}

class GasTripViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

  var authStatus: AuthStatus?

  @Published var totalPriceString: String = ""
  @Published var gallonsString: String = ""
  @Published var stationString: String = ""
  @Published var addressString: String = ""
  @Published var locationStatus: LocationStatus = .idle

  private var cancellables: Set<AnyCancellable> = []

  override init() {
    super.init()
    let sharedLocationSubject = self.locationSubject.share().eraseToAnyPublisher()
    self.locationUpdateCancellable(locationSubject: sharedLocationSubject)
      .store(in: &cancellables)
    self.gasStationLookupCancellable(locationSubject: sharedLocationSubject)
      .store(in: &cancellables)
  }

  // MARK: firebase/firestore functions

  private let tripCollection = Firestore.firestore().collection("trips")

  func save(onCompletion: @escaping (Bool) -> Void) {
    guard let uid = authStatus?.uid else {
      print("Not logged in")
      return
    }
    guard let totalPrice = Double(totalPriceString), let gallons = Double(gallonsString) else {
      return
    }
    let location: Location?
    if let lastCoordinate = self.locationSubject.value?.coordinate {
      location = Location(from: lastCoordinate)
    } else {
      location = nil
    }
    let newTrip = GasTrip(
      userID: uid,
      totalPrice: totalPrice,
      gallons: gallons,
      station: stationString,
      streetAddress: addressString,
      date: Date(),
      location: location)
    _ = try? self.tripCollection.addDocument(
      from: newTrip,
      completion: { error in
        if let error = error {
          print("Save error: \(error)")
          onCompletion(false)
        } else {
          onCompletion(true)
        }
      })
  }

  // MARK: location functions

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 30  // meters
    return locationManager
  }()

  private var locationSubject: CurrentValueSubject<CLLocation?, Never> = CurrentValueSubject(nil)

  private func locationAuthorized() -> Bool {
    return self.locationManager.authorizationStatus == .authorizedAlways
      || self.locationManager.authorizationStatus == .authorizedWhenInUse
  }

  private func locationUpdateCancellable(locationSubject: AnyPublisher<CLLocation?, Never>)
    -> AnyCancellable
  {
    return
      locationSubject
      .receive(on: DispatchQueue.main)
      .sink { newLocation in
        guard let newLocation = newLocation else {
          return
        }
        if case .locatedWithAddess(let oldLocation, station: let station, address: let address) =
          self
          .locationStatus,
          oldLocation.distance(from: newLocation) < 20
        {
          self.locationStatus = .locatedWithAddess(newLocation, station: station, address: address)
        } else {
          self.locationStatus = .locatedNoAddress(newLocation)
        }
      }
  }

  private func gasStationLookupCancellable(locationSubject: AnyPublisher<CLLocation?, Never>)
    -> AnyCancellable
  {
    return
      locationSubject
      .compactMap { $0?.coordinate }
      .debounce(for: .seconds(1), scheduler: RunLoop.main)
      .findGasStations(radius: 50)
      .sink { result in
        switch result {
        case .success(let response):
          let currLocation: CLLocation
          switch self.locationStatus {
          case .locatedNoAddress(let location):
            currLocation = location
          case .locatedWithAddess(let location, station: _, address: _):
            currLocation = location
          default:
            return
          }
          let nearestStations = response.mapItems.sorted { itemA, itemB in
            return currLocation.distance(to: itemA) < currLocation.distance(to: itemB)
          }
          guard let nearestStation = nearestStations.first else {
            print("No nearby stations found")
            return
          }
          let address = [
            nearestStation.placemark.thoroughfare, nearestStation.placemark.subLocality,
          ].compactMap { $0 }.joined(separator: ", ")
          self.locationStatus = .locatedWithAddess(
            currLocation,
            station: nearestStation.name ?? "",
            address: address)
        case .failure(let error):
          print("Search error: \(error)")
        }
      }
  }

  func requestAuthorization() {
    guard self.locationManager.authorizationStatus == .notDetermined else {
      return
    }
    self.locationManager.requestWhenInUseAuthorization()
  }

  func startUpdatingLocation() {
    guard self.locationAuthorized() else {
      self.locationStatus = .notAuthorized
      return
    }
    self.locationSubject.send(nil)
    self.locationStatus = .locating
    self.locationManager.startUpdatingLocation()
  }

  func stopUpdatingLocation() {
    self.locationManager.stopUpdatingLocation()
    self.locationSubject.send(nil)
  }

  // MARK: CLLocationManagerDelegate

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("Authorization did change: \(self.locationManager.authorizationStatus.rawValue)")
    switch self.locationManager.authorizationStatus {
    case .restricted, .denied:
      self.locationStatus = .notAuthorized
    default:
      self.locationStatus = .idle
      self.startUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let lastLocation = locations.last else {
      return
    }
    self.locationSubject.send(lastLocation)
  }

}

extension CLLocation {
  fileprivate func distance(to mapItem: MKMapItem) -> CLLocationDistance {
    let mapItemCoord = mapItem.placemark.coordinate
    let mapItemLoc = CLLocation(latitude: mapItemCoord.latitude, longitude: mapItemCoord.longitude)
    return self.distance(from: mapItemLoc)
  }
}

extension Publisher where Self.Output == CLLocationCoordinate2D {
  fileprivate func findGasStations(radius: CLLocationDistance)
    -> AnyPublisher<Result<MKLocalSearch.Response, Error>, Self.Failure>
  {
    return self.flatMap { newLocation in
      return Future<Result<MKLocalSearch.Response, Error>, Self.Failure> { promise in
        let request = MKLocalPointsOfInterestRequest(
          center: newLocation, radius: radius)
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.gasStation])
        let search = MKLocalSearch(request: request)
        search.start { response, error in
          guard let response = response else {
            promise(.success(.failure(error!)))
            return
          }
          promise(.success(.success(response)))
        }
      }
    }.eraseToAnyPublisher()
  }
}
