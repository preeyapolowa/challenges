//
//  UINavigationControllerSpy.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import UIKit

class UINavigationControllerSpy: UINavigationController {
    var pushViewControllerCalled = false
    var popViewControllerCalled = false
    
    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: animated)
        popViewControllerCalled = true
        return viewControllers.last
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerCalled = true
    }
}
