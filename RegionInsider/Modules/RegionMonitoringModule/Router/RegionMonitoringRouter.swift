//
//  RegionMonitoringRouter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/28/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionMonitoringRouterInput: AnyObject {
  func toBack()
  func toAlert(title: String?, message: String)
}

class RegionMonitoringRouter: BaseRouter {
  weak var view: RegionMonitoringViewInput?
}

extension RegionMonitoringRouter: RegionMonitoringRouterInput {
  func toBack() {
    pop(animated: true)
  }
  
  func toAlert(title: String?, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
