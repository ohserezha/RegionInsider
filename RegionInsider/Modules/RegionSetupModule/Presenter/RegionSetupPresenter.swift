//
//  RegionSetupPresenter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import Foundation

protocol RegionSetupViewOutput: AnyObject {
  
}

final class RegionSetupPresenter: RegionSetupViewOutput {
  weak var view: RegionSetupViewInput?
}