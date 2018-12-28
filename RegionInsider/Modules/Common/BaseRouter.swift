//
//  BaseRouter.swift
//  RegionInsider
//
//  Created by Sergey G on 12/28/18.
//  Copyright © 2018 Sergey G. All rights reserved.
//

import UIKit

protocol BaseRouter {
  associatedtype InputType: Any
  
  var view: InputType? { get set }
  var viewController: UIViewController? { get }
  var navigationController: UINavigationController? { get }
  
  func dismiss(animated: Bool, completion: (() -> Void)?)
  func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
  func pop(animated: Bool)
  func push(_ viewController: UIViewController, animated: Bool)
}

extension BaseRouter {
  var viewController: UIViewController? {
    return view as? UIViewController
  }
  
  var navigationController: UINavigationController? {
    return viewController?.navigationController
  }
  
  func dismiss(animated: Bool, completion: (() -> Void)?) {
    viewController?.dismiss(animated: animated, completion: completion)
  }
  
  func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    self.viewController?.present(viewController, animated: animated, completion: completion)
  }
  
  func pop(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }
  
  func push(_ viewController: UIViewController, animated: Bool) {
    navigationController?.pushViewController(viewController, animated: animated)
  }
}
