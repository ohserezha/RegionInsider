//
//  RegionMonitoringPresenter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import Foundation

protocol RegionMonitoringViewOutput: AnyObject {
  func viewIsReady()
  func viewDidAppear()
  func viewWillDisappear()
}

final class RegionMonitoringPresenter {
  weak var view: RegionMonitoringViewInput?
  var router: RegionMonitoringRouter!
  
  var locationService: LocationService!
}

extension RegionMonitoringPresenter: RegionMonitoringViewOutput {
  func viewIsReady() {
    view?.configure(state: .undefined)
    locationService.delegate = self
  }
  
  func viewDidAppear() {
    defineRegionStatus()
  }
  
  func viewWillDisappear() {
    locationService.stopMonitoring()
  }
}

private extension RegionMonitoringPresenter {
  func defineRegionStatus() {
    locationService.checkIfInsideMonitoredLocations()
  }
}

extension RegionMonitoringPresenter: LocationServiceDelegate {
  func locationServiceWasAuthorized(service: LocationService) {
    defineRegionStatus()
  }
  
  func locationService(_ service: LocationService, didDetermineRegionState state: RegionState) {
    view?.configure(state: state)
  }
  
  func locationService(_ service: LocationService, didFail error: Error) {
    router.toAlert(title: "An error occured",
                   message: error.localizedDescription)
  }
  
  func locationServicesDisabled() {
    router.toAlert(title: "Enable usage of location services always",
                   message: "This app requires such permissions to properly monitor regions")
  }
}
