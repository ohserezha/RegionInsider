//
//  RegionSetupPresenter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import Foundation

protocol RegionSetupViewOutput: AnyObject {
  func viewIsReady()
  func saveButtonTapped()
}

final class RegionSetupPresenter: RegionSetupViewOutput {
  weak var view: RegionSetupViewInput?
  
  func viewIsReady() {
    
  }
  
  func saveButtonTapped() {
    
  }
}
