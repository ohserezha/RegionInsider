//
//  RegionSetupPresenter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import Foundation
import CoreLocation


protocol RegionSetupViewOutput: AnyObject {
  func viewIsReady()
  func proceed(with input: RegionSetupViewConfiguration)
  func validateInputField(_ input: String?, for textFieldType: InputValueType) -> Bool
}


final class RegionSetupPresenter: RegionSetupViewOutput {
  weak var view: RegionSetupViewInput?
  
  var locationService: LocationService!
  var viewModel: RegionSetupViewConfiguration?
  
  func viewIsReady() {
    let viewConfiguration = RegionSetupViewConfiguration()
    view?.configure(with: viewConfiguration)
  }
  
  /// proceed with provided input
  func proceed(with input: RegionSetupViewConfiguration) {
    // keeps track if entities' details provided
    var shouldProceed = false
    
    if
      let lat = input.lat, !lat.isEmpty,
      let long = input.long, !long.isEmpty,
      let radius = input.radius, !radius.isEmpty {
        let centerCoordinate = CLLocationCoordinate2DMake(Double(lat) ?? 0.0, Double(long) ?? 0.0)
        let region = CLCircularRegion(center: centerCoordinate,
                                    radius: Double(radius) ?? 0.0,
                                    identifier: "region")
        locationService.monitoredGeoRegion = region
        shouldProceed = true
    }
    
    if let ssid = input.SSID, !ssid.isEmpty {
      locationService.monitoredNetworkSSID = ssid
      shouldProceed = true
    }
    
    if !shouldProceed {
      view?.showAlert(title: "Nothing to monitor", message: "You have to provide at least one fully described item to monitor")
    } else {
      // router.toRegionMonitoring()
    }
  }
  
  /// validate separate textField text relative to type of input
  func validateInputField(_ text: String?, for valueType: InputValueType) -> Bool {
    guard let text = text, text != "" else { return true }
    
    switch valueType {
    case .latitude:
      if let value = Double(text), value < 90, value > -90 {
        return true
      } else {
        view?.showAlert(title: "Wrong value", message: "latitude has to be between -90 and 90")
      }
    case .longitude:
      if let value = Double(text), value < 180, value > -180 {
        return true
      } else {
        view?.showAlert(title: "Wrong value", message: "longitude has to be between -180 and 180")
      }
    case .radius:
      if let value = Double(text), value >= 100 {
        return true
      } else {
        view?.showAlert(title: "Wrong value", message: "radius has to be greater than 100")
      }
    default:
      return true
    }
    
    return false
  }
}


/// RegionSetupView configuration struct
struct RegionSetupViewConfiguration {
  var lat: String?
  var long: String?
  var radius: String?
  var SSID: String?
  
  init(lat: String? = nil, long: String? = nil, radius: String? = nil, SSID: String? = nil) {
    self.lat = lat
    self.long = long
    self.radius = radius
    self.SSID = SSID
  }
}
