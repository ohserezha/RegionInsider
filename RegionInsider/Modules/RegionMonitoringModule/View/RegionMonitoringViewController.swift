//
//  RegionMonitoringViewController.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionMonitoringViewInput: AnyObject {
  func configure(state: RegionState)
}

class RegionMonitoringViewController: UIViewController {
  // MARK: - Output
  var output: RegionMonitoringViewOutput!
  
  // MARK: - Outlets
  @IBOutlet private weak var stateView: UIView!
  @IBOutlet private weak var stateLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    output.viewIsReady()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    output.viewDidAppear()
  }
  
  override func viewDidLayoutSubviews() {
    configureUI()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    output.viewWillDisappear()
  }
}

extension RegionMonitoringViewController: RegionMonitoringViewInput {
  func configure(state: RegionState) {
    switch state {
    case .inside:
      stateView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
      stateLabel.text = "INSIDE"
    case .outside:
      stateView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
      stateLabel.text = "OUTSIDE"
    case .undefined:
      stateView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
      stateLabel.text = "UNDEFINED"
    }
  }
}

private extension RegionMonitoringViewController {
  func configureUI() {
    stateView.layer.cornerRadius = stateView.frame.size.width / 2.0
  }
}
