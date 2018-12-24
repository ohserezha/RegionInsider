//
//  UIViewController+StoryboardIdentifiable.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
  static var storyboardID: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardID: String {
    return String(describing: self)
  }
}

extension UIViewController: StoryboardIdentifiable {}
