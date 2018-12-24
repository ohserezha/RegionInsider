//
//  UIStoryboard+create.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

extension UIStoryboard {
  class func create<T: UIViewController>(_ viewController: T.Type) -> T {
    let storyboard = UIStoryboard(name: viewController.storyboardID, bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: T.storyboardID) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.storyboardID) ")
    }
    return viewController
  }
}
