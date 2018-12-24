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
}

final class RegionMonitoringPresenter {
  weak var view: RegionMonitoringViewInput?
}

extension RegionMonitoringPresenter: RegionMonitoringViewOutput {
  func viewIsReady() {
    view?.configure(state: .outside)
  }
}

enum UserLocationState {
  case inside
  case outside
}
