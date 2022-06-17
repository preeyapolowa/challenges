//
//  SuccessRouter.swift
//  OpnChallenge

import UIKit

protocol SuccessRouterInput: AnyObject {
    func createVC() -> UIViewController
}

final class SuccessRouter: SuccessRouterInput {
    weak var viewController: SuccessViewController!

    // MARK: - Navigation

    func createVC() -> UIViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Success", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SuccessViewController")
        return vc
    }
}
