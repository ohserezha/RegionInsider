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
  func saveInput(_ input: RegionSetupViewConfiguration)
  func validateInput(_ input: String?, for textFieldType: TextFieldType) -> Bool
}

final class RegionSetupPresenter: RegionSetupViewOutput {
  weak var view: RegionSetupViewInput?
  
  var locationService: LocationService!
  var viewModel: RegionSetupViewConfiguration?
  
  func viewIsReady() {
    locationService.delegate = self
    view?.configure(with: RegionSetupViewConfiguration())
  }
  
  func saveInput(_ input: RegionSetupViewConfiguration) {
    
  }
  
  func validateInput(_ input: String?, for textFieldType: TextFieldType) -> Bool {
    guard let input = input else { return true }
    
    switch textFieldType {
    case .SSID:
      //      locationService.startMonitoringNetworkRegion()
      return true
    case .latitude:
      if let value = Double(input), value < 90, value > -90 {
        return true
      } else {
        view?.showAlert(title: "Wrong value", message: "latitude has to be between -90 and 90")
      }
    case .longitude:
      if let value = Double(input), value < 180, value > -180 {
        return true
      } else {
        view?.showAlert(title: "Wrong value", message: "longitude has to be between -180 and 180")
      }
    case .radius:
      if let value = Double(input), value > 100 {
        return true
      } else {
        view?.showAlert(title: "Wrong value", message: "radius has to be greater than 100")
      }
    case .undefined:
      return true
    }
    
    return false
  }
}

extension RegionSetupPresenter: LocationServiceDelegate {
  func locationServicesDisabled() {
    view?.showAlert(title: "Enable usage of location services always",
                    message: "This app requires such permissions to properly monitor regions")
  }
  
  func locationService(_ service: LocationService, didFail error: Error) {
    view?.showAlert(title: "An error occured",
                    message: error.localizedDescription)
  }
}

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
