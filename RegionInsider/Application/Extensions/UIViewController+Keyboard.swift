//
//  UIViewController+Keyboard.swift
//  RegionInsider
//
//  Created by Sergey G on 12/24/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol KeyboardHideable: AnyObject {
  func hideKeyboardOnTapAround()
}

extension UIViewController: KeyboardHideable {
  func hideKeyboardOnTapAround() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: .hideKeyboard)
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc fileprivate func hideKeyboard() {
    view.endEditing(true)
  }
}

private extension Selector {
  static let hideKeyboard = #selector(UIViewController.hideKeyboard)
}
