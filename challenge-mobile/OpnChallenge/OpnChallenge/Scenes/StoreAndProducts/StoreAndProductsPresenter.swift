//
//  StoreAndProductsPresenter.swift
//  OpnChallenge

import UIKit

protocol StoreAndProductsPresenterOutput: AnyObject {
    func presentStoreInfo(response: StoreAndProductsModels.GetStoreInfo.Response)
    func presentProducts(response: StoreAndProductsModels.GetProducts.Response)
}

final class StoreAndProductsPresenter: StoreAndProductsPresenterOutput {
    var viewController: StoreAndProductsViewControllerOutput?

    // MARK: - Presentation logic

    func presentStoreInfo(response: StoreAndProductsModels.GetStoreInfo.Response) {
        let viewModel = StoreAndProductsModels.GetStoreInfo.ViewModel(data: response.data)
        viewController?.displayStoreInfo(viewModel: viewModel)
    }
    
    func presentProducts(response: StoreAndProductsModels.GetProducts.Response) {
        let viewModel = StoreAndProductsModels.GetProducts.ViewModel(data: response.data)
        viewController?.displayProducts(viewModel: viewModel)
    }
}
