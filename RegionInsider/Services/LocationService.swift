//
//  LocationService.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import CoreLocation


enum RegionState {
  case inside
  case outside
  case undefined
}


protocol LocationServiceDelegate: class {
  func locationServiceWasAuthorized(service: LocationService)
  func locationService(_ service: LocationService, didDetermineRegionState state: RegionState)
  func locationService(_ service: LocationService, didFail error: Error)
  func locationServicesDisabled()
}

extension LocationServiceDelegate {
  func locationServiceWasAuthorized(service: LocationService) {}
  func locationService(_ service: LocationService, didDetermineRegionState: RegionState) {}
  func locationService(_ service: LocationService, didFail error: Error) {}
  func locationServicesDisabled() {}
}


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

  // resolve permissions and start defining state
  func checkIfInsideMonitoredLocations() {
    let authStatus = CLLocationManager.authorizationStatus()
    switch authStatus {
    case .authorizedAlways:
      defineCurrentState()
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    default:
      delegate?.locationServicesDisabled()
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
  /// defines if device is inside of at least one of monitored locations (region or network)
  /// and calls delegate's locationService(:didDetermineRegionState)
  func defineCurrentState() {
    // we check for network first as it takes no time
    if monitoredNetworkState() == .inside {
      delegate?.locationService(self, didDetermineRegionState: monitoredNetworkState())
    } else if let monitoredGeoRegion = monitoredGeoRegion {
      startMonitoringGeoRegion(monitoredGeoRegion)
      // after request below app waits for resolving status by locationManager, combines result on completion
      // and returns result to self's delegate
      locationManager.requestState(for: monitoredGeoRegion)
    } else {
      delegate?.locationService(self, didDetermineRegionState: .undefined)
    }
  }
  
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
  
  func stopMonitoringGeoRegion(_ region: CLRegion) {
    locationManager.stopMonitoring(for: region)
  }
}


extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    case .authorizedWhenInUse, .denied, .restricted:
      delegate?.locationServicesDisabled()
    case .authorizedAlways:
      delegate?.locationServiceWasAuthorized(service: self)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    delegate?.locationService(self, didFail: error)
  }
  
  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    let resultingState = combineStates(geoRegionState: state, networkRegionState: monitoredNetworkState())
    delegate?.locationService(self, didDetermineRegionState: resultingState)
    stopMonitoringGeoRegion(region)
  }
}
