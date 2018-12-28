//
//  RegionSetupViewController.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol RegionSetupViewInput: AnyObject {
  func configure(with configuration: RegionSetupViewConfiguration)
  func showAlert(title: String?, message: String)
}

enum TextFieldType {
  case latitude
  case longitude
  case radius
  case SSID
  case undefined
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
  
  @IBOutlet private weak var saveRegionsButton: UIButton!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardOnTapAround()
    configureUI()
    output.viewIsReady()
  }
  
  // MARK: - Actions
  @IBAction private func didTapSaveButton(_ sender: Any) {
    let viewConfiguration = RegionSetupViewConfiguration(lat: latitudeTextField.text,
                                                         long: longitudeTextField.text,
                                                         radius: regionRadiusTextField.text,
                                                         SSID: networkSSIDTextField.text)
    output.saveInput(viewConfiguration)
  }
}

extension RegionSetupViewController: RegionSetupViewInput {
  func configure(with configuration: RegionSetupViewConfiguration) {
    
  }
  
  func showAlert(title: String?, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

extension RegionSetupViewController: UITextFieldDelegate {
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    var textFieldType: TextFieldType
    
    switch textField {
    case longitudeTextField:
      textFieldType = .longitude
    case latitudeTextField:
      textFieldType = .latitude
    case regionRadiusTextField:
      textFieldType = .radius
    case networkSSIDTextField:
      textFieldType = .SSID
    default:
      textFieldType = .undefined
    }
    
    return output.validateInput(textField.text, for: textFieldType)
  }
}

private extension RegionSetupViewController {
  enum Constants {
    static let labelFontSize: CGFloat = 12
    static let headerFontSize: CGFloat = 14
  }
  
  func configureUI() {
    // Labels
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
    
    networkSSIDTextField.keyboardType = .asciiCapable
    networkSSIDTextField.delegate = self
    
    // Text Fields
    latitudeTextField.keyboardType = .decimalPad
    latitudeTextField.delegate = self
    
    longitudeTextField.keyboardType = .decimalPad
    longitudeTextField.delegate = self
    
    regionRadiusTextField.keyboardType = .numberPad
    regionRadiusTextField.delegate = self
    
    networkSSIDLabel.text = "Wi-Fi name"
    networkSSIDLabel.font = .systemFont(ofSize: Constants.labelFontSize)
    
    // Buttons
    saveRegionsButton.setTitle("Save Regions", for: .normal)
  }
}
