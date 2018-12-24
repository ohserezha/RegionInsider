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
  
  var output: RegionSetupViewOutput!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
}

extension RegionSetupViewController: RegionSetupViewInput {
  func configure() {
    
  }
}
