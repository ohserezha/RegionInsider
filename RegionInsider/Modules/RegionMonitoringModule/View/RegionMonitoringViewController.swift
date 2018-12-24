//
//  RegionMonitoringViewController.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionMonitoringViewInput: AnyObject {
  func configure(state: UserLocationState)
}

class RegionMonitoringViewController: UIViewController {
  // MARK: - Output
  var output: RegionMonitoringViewOutput!
  
  // MARK: - Outlets
  @IBOutlet private weak var stateView: UIView!
  @IBOutlet private weak var stateLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    output.viewIsReady()
  }
}

extension RegionMonitoringViewController: RegionMonitoringViewInput {
  func configure(state: UserLocationState) {
    switch state {
    case .inside:
      stateView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
      stateLabel.text = "INSIDE"
    case .outside:
      stateView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
      stateLabel.text = "OUTSIDE"
    }
  }
}

private extension RegionMonitoringViewController {
  func configureUI() {
    stateView.layer.cornerRadius = stateView.bounds.size.width / 2.0
  }
}
