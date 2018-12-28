//
//  RegionSetupRouter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/28/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionSetupRouterInput: AnyObject {
  func toMonitoring()
  func toAlert(title: String?, message: String)
}

class RegionSetupRouter: BaseRouter {
  weak var view: RegionSetupViewInput?
}

extension RegionSetupRouter: RegionSetupRouterInput {
  func toMonitoring() {
    let monitoringModule = RegionMonitoringModuleFactory.makeRegionMonitoringModule()
    push(monitoringModule, animated: true)
  }
  
  func toAlert(title: String?, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
