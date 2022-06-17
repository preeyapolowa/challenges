//
//  OrderSummaryInteractor.swift
//  OpnChallenge

import UIKit

protocol OrderSummaryInteractorOutput: AnyObject {
    var datas: [ProductsModel] { get set }
    func makeOrder(request: OrderSummaryModels.MakeOrder.Request)
}

final class OrderSummaryInteractor: OrderSummaryInteractorOutput {
    var presenter: OrderSummaryPresenterOutput!
    var worker = Worker(store: Store())
    var datas: [ProductsModel] = [ProductsModel]()
    
    // MARK: - Business logic

    func makeOrder(request: OrderSummaryModels.MakeOrder.Request) {
        worker.makeOrder(request: request.request)
        presenter.presentMakeOrder(response: OrderSummaryModels.MakeOrder.Response())
    }
}
