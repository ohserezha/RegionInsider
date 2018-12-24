//
//  LocationService.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
  func locationService(_ service: LocationService, didChangeAuthorization status: CLAuthorizationStatus)
  func locationService(_ service: LocationService, didUpdateLocation location: CLLocation)
  func locationService(_ service: LocationService, didEnterRegion region: CLCircularRegion)
  func locationService(_ service: LocationService, didExitRegion region: CLCircularRegion)
  func showLocationDisabledAlert()
}

extension LocationServiceDelegate {
  func locationService(_ service: LocationService, didChangeAuthorization status: CLAuthorizationStatus) {}
  func locationService(_ service: LocationService, didUpdateLocation location: CLLocation) {}
  func locationService(_ service: LocationService, didEnterRegion region: CLCircularRegion) {}
  func locationService(_ service: LocationService, didExitRegion region: CLCircularRegion) {}
  func showLocationDisabledAlert() {}
}

class LocationService: NSObject {
  private let locationManager = CLLocationManager()
  weak var delegate: LocationServiceDelegate?
  
  var location: CLLocation? {
    return locationManager.location
  }
  
  override init() {
    super.init()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.delegate = self
    startMonitoringLocation()
  }
  
  func authorizationStatus() -> CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }
  
  func requestAlwaysAuthorization() {
    locationManager.requestAlwaysAuthorization()
  }
  
  func requestWhenInUseAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func startMonitoringLocation() {
    locationManager.startUpdatingLocation()
  }
  
  func stopMonitoringLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  func startMonitoringRegions(_ regionList: [CLCircularRegion]) {
    clearAllMonitoredRegions()
    guard
      CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self),
      CLLocationManager.authorizationStatus() == .authorizedAlways else {
        return
    }
    regionList.forEach { locationManager.startMonitoring(for: $0) }
  }
  
  func showLocationDisabledAlert() {
    delegate?.showLocationDisabledAlert()
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
    locationManager.monitoredRegions.forEach {
      locationManager.stopMonitoring(for: $0)
    }
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      locationManager.allowsBackgroundLocationUpdates = true
    }
    delegate?.locationService(self, didChangeAuthorization: status)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      delegate?.locationService(self, didUpdateLocation: location)
    }
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
}
