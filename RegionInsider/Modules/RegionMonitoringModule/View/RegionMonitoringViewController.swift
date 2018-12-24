//
//  RegionMonitoringViewController.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionMonitoringViewInput: AnyObject {
  func configure()
}

class RegionMonitoringViewController: UIViewController {
  var output: RegionMonitoringViewOutput!
}

extension RegionMonitoringViewController: RegionMonitoringViewInput {
  func configure() {
    
  }
}
