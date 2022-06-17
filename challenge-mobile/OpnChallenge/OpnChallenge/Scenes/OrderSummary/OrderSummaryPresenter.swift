//
//  OrderSummaryPresenter.swift
//  OpnChallenge

import UIKit

protocol OrderSummaryPresenterOutput: AnyObject {
    func presentMakeOrder(response: OrderSummaryModels.MakeOrder.Response)
}

final class OrderSummaryPresenter: OrderSummaryPresenterOutput {
    weak var viewController: OrderSummaryViewControllerOutput?

    // MARK: - Presentation logic
    func presentMakeOrder(response: OrderSummaryModels.MakeOrder.Response) {
        viewController?.displayMakeOrder(viewModel: OrderSummaryModels.MakeOrder.ViewModel())
    }
}
