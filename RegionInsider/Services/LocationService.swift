//
//  LocationService.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import CoreLocation

let region = CLCircularRegion(center: CLLocationCoordinate2DMake(50.363343, 30.596162), radius: 300, identifier: "arsenalna")

enum RegionState {
  case inside
  case outside
  case undefined
}


protocol LocationServiceDelegate: class {
  func locationService(_ service: LocationService, didDetermineRegionState: RegionState)
  func locationService(_ service: LocationService, didFail error: Error)
  func locationServicesDisabled()
}
//
//extension LocationServiceDelegate {
//  func locationService(_ service: LocationService, didDetermineRegionState: RegionState) {}
//  func locationService(_ service: LocationService, didFail error: Error) {}
//  func locationServicesDisabled() {}
//}


typealias SSID = String

class LocationService: NSObject {
  static let shared = LocationService()
  private let locationManager: CLLocationManager
  
  weak var delegate: LocationServiceDelegate?
  
  var monitoredGeoRegion: CLCircularRegion?
  var monitoredNetworkSSID: SSID?
  
  private override init() {
    locationManager = CLLocationManager()
    super.init()
    locationManager.delegate = self
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }
  
  func checkPermissionsAndStartMonitoring() {
    let authStatus = CLLocationManager.authorizationStatus()
    switch authStatus {
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    case .authorizedAlways:
      startMonitoringGeoRegion(region)
    default:
      delegate?.locationServicesDisabled()
    }
  }
  
  /// checks if device is inside of at least one of monitored locations (region or network)
  /// and calls delegate's locationService(_:didDetermineRegionState)
  func checkIfInsideMonitoredLocations() {
    if let monitoredGeoRegion = monitoredGeoRegion {
      startMonitoringGeoRegion(monitoredGeoRegion)
      locationManager.requestState(for: monitoredGeoRegion)
    } else {
      return
    }
  }
  
  func stopMonitoring() {
    if let monitoredGeoRegion = monitoredGeoRegion {
      locationManager.stopMonitoring(for: monitoredGeoRegion)
      self.monitoredGeoRegion = nil
    }
    monitoredNetworkSSID = nil
  }
}


private extension LocationService {
  /// checks if device is inside network with provided SSID
  func monitoredNetworkState() -> RegionState {
    if let _ = monitoredNetworkSSID {
      /*
       here had to be obtaibing network SSID and compare it to monitoredNetworkSSID
       but i don't have apple developer program enrollment
       thereby i can't add Wireless Info Access to app's entitlements
       and induced to return .undefined =(
      */
      return .undefined
    } else {
      return .undefined
    }
  }
  
  /// starts monitoring provided CLRegion
  func startMonitoringGeoRegion(_ region: CLCircularRegion) {
    for region in locationManager.monitoredRegions {
      locationManager.stopMonitoring(for: region)
    }
    guard
      CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self),
      CLLocationManager.authorizationStatus() == .authorizedAlways else {
        delegate?.locationServicesDisabled()
        return
    }
    monitoredGeoRegion = region
    locationManager.startMonitoring(for: region)
  }
  
  func combineStates(geoRegionState: CLRegionState, networkRegionState: RegionState) -> RegionState {
    switch (geoRegionState, networkRegionState) {
    case (.inside, _):
      return .inside
    case (_, .inside):
      return .inside
    case (.outside, _):
      return .outside
    case (_, .outside):
      return .outside
    default:
      return .undefined
    }
  }
}


extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkPermissionsAndStartMonitoring()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    delegate?.locationService(self, didFail: error)
  }
  
  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    let resultingState = combineStates(geoRegionState: state, networkRegionState: monitoredNetworkState())
    delegate?.locationService(self, didDetermineRegionState: resultingState)
  }
}
