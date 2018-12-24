//
//  RegionSetupModuleFactory.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

final class RegionSetupModuleFactory {
  class func makeRegionSetupModule() -> UIViewController {
    let controller = UIStoryboard.create(RegionSetupViewController.self)
    
//    let router = RegionSetupRouter()
//    router.view = controller
    
    let presenter = RegionSetupPresenter()
    presenter.view = controller
//    presenter.router = router
    
    controller.output = presenter
    
    return controller
  }
}
