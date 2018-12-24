//
//  RegionSetupViewController.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionSetupViewInput: AnyObject {
  func configure()
}

class RegionSetupViewController: UIViewController {
  // MARK: - Output
  var output: RegionSetupViewOutput!
  
  // MARK: - Outlets
  @IBOutlet private weak var geoRegionHeaderLabel: UILabel!
  @IBOutlet private weak var latitudeLabel: UILabel!
  @IBOutlet private weak var latitudeTextField: UITextField!
  @IBOutlet private weak var longitudeLabel: UILabel!
  @IBOutlet private weak var longitudeTextField: UITextField!
  @IBOutlet private weak var regionRadiusLabel: UILabel!
  @IBOutlet private weak var regionRadiusTextField: UITextField!
  
  @IBOutlet private weak var networkRegionHeaderLabel: UILabel!
  @IBOutlet private weak var networkSSIDLabel: UILabel!
  @IBOutlet private weak var networkSSIDTextField: UITextField!
  
  @IBOutlet private weak var addGeoRegionsButton: UIButton!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Actions
  @IBAction private func didTapSaveButton(_ sender: Any) {
    // output.saveButtonTapped()
  }
}

extension RegionSetupViewController: RegionSetupViewInput {
  func configure() {
    
  }
}

extension RegionSetupViewController: UITextFieldDelegate {
  
}

private extension RegionSetupViewController {
  enum Constants {
    static let labelFontSize: CGFloat = 12
    static let headerFontSize: CGFloat = 14
  }
  
  func configureUI() {
    navigationItem.title = "Setup Regions"
    
    geoRegionHeaderLabel.text = "Geo Region"
    geoRegionHeaderLabel.font = .systemFont(ofSize: Constants.headerFontSize)
    
    latitudeLabel.text = "center latitude"
    latitudeLabel.font = .systemFont(ofSize: Constants.labelFontSize)
    
    longitudeLabel.text = "center longitude"
    longitudeLabel.font = .systemFont(ofSize: Constants.labelFontSize)
    
    regionRadiusLabel.text = "radius"
    regionRadiusLabel.font = .systemFont(ofSize: Constants.labelFontSize)
    
    networkRegionHeaderLabel.text = "Network Region"
    networkRegionHeaderLabel.font = .systemFont(ofSize: Constants.headerFontSize)
    
    networkSSIDLabel.text = "Wi-Fi name"
    networkSSIDLabel.font = .systemFont(ofSize: Constants.labelFontSize)
    
    addGeoRegionsButton.setTitle("Save Regions", for: .normal)
  }
}
