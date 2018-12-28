//
//  RegionMonitoringModuleFactory.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

final class RegionMonitoringModuleFactory {
  class func makeRegionMonitoringModule() -> UIViewController {
    let controller = UIStoryboard.create(RegionMonitoringViewController.self)
    
    let router = RegionMonitoringRouter()
    router.view = controller
    
    let presenter = RegionMonitoringPresenter()
    presenter.view = controller
    presenter.router = router
    presenter.locationService = LocationService.shared
    
    controller.output = presenter
    
    return controller
  }
}
