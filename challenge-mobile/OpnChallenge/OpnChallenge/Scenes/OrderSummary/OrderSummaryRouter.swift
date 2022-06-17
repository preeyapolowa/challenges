//
//  OrderSummaryRouter.swift
//  OpnChallenge

import UIKit

protocol OrderSummaryRouterInput: AnyObject {
    func createVC() -> UIViewController
    func navigateBack()
    func navigateToSuccess()
}

final class OrderSummaryRouter: OrderSummaryRouterInput {
    weak var viewController: OrderSummaryViewController!

    // MARK: - Navigation

    func createVC() -> UIViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "OrderSummary", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OrderSummaryViewController")
        return vc
    }
    
    func navigateBack() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func navigateToSuccess() {
        let vc = SuccessRouter().createVC()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
