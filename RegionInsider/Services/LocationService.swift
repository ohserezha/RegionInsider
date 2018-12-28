//
//  LocationService.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
  func locationService(_ service: LocationService, didEnterRegion region: CLCircularRegion)
  func locationService(_ service: LocationService, didExitRegion region: CLCircularRegion)
  func locationService(_ service: LocationService, didDetermineRegionState: CLRegionState)
  func locationService(_ service: LocationService, didFail error: Error)
  func locationServicesDisabled()
}

extension LocationServiceDelegate {
  func locationService(_ service: LocationService, didEnterRegion region: CLCircularRegion) {}
  func locationService(_ service: LocationService, didExitRegion region: CLCircularRegion) {}
  func locationService(_ service: LocationService, didDetermineRegionState: CLRegionState) {}
  func locationService(_ service: LocationService, didFail error: Error) {}
  func locationServicesDisabled() {}
}

typealias SSID = String

class LocationService: NSObject {
  static let shared = LocationService()
  private let locationManager: CLLocationManager
  
  weak var delegate: LocationServiceDelegate?
  var monitoredRegion: CLRegion?
  var monitoredNetwork: SSID?
  
  private override init() {
    locationManager = CLLocationManager()
    super.init()
    locationManager.delegate = self
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }
  
  func updateLocation() {
    let authStatus = CLLocationManager.authorizationStatus()
    switch authStatus {
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    case .authorizedAlways:
      let region = CLCircularRegion(center: CLLocationCoordinate2DMake(50.363343, 30.596162), radius: 300, identifier: "arsenalna")
      startMonitoringGeoRegion(region)
      isInsideMonitoredRegion()
    default:
      delegate?.locationServicesDisabled()
    }
  }
  
  func isInsideMonitoredRegion() {
    if let monitoredRegion = monitoredRegion {
      locationManager.requestState(for: monitoredRegion)
    } else {
      return
    }
  }
  
  func startMonitoringGeoRegion(_ region: CLCircularRegion) {
    clearAllMonitoredRegions()
    guard
      CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self),
      CLLocationManager.authorizationStatus() == .authorizedAlways else {
        delegate?.locationServicesDisabled()
        return
    }
    monitoredRegion = region
    locationManager.startMonitoring(for: region)
  }
  
  static func stopMonitoringRegions() {
    let locationManager = CLLocationManager()
    for region in locationManager.monitoredRegions {
      locationManager.stopMonitoring(for: region)
    }
  }
}

private extension LocationService {
  func clearAllMonitoredRegions() {
    monitoredRegion = nil
    locationManager.monitoredRegions.forEach {
      locationManager.stopMonitoring(for: $0)
    }
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    updateLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if let region = region as? CLCircularRegion {
      delegate?.locationService(self, didEnterRegion: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if let region = region as? CLCircularRegion {
      delegate?.locationService(self, didExitRegion: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    delegate?.locationService(self, didFail: error)
  }
  
  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    delegate?.locationService(self, didDetermineRegionState: state)
  }
}
