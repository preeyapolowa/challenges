//
//  StoreAndProductsRouter.swift
//  OpnChallenge

import UIKit

protocol StoreAndProductsRouterInput: AnyObject {
    func createVC() -> UIViewController
    func navigateToOrderSummary(datas: [ProductsModel])
}

final class StoreAndProductsRouter: StoreAndProductsRouterInput {
    weak var viewController: StoreAndProductsViewController!

    // MARK: - Navigation

    func createVC() -> UIViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "StoreAndProducts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StoreAndProductsViewController")
        return vc
    }
    
    func navigateToOrderSummary(datas: [ProductsModel]) {
        let vc = OrderSummaryRouter().createVC() as? OrderSummaryViewController
        vc?.interactor.datas = datas
        viewController.navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
    }
}
