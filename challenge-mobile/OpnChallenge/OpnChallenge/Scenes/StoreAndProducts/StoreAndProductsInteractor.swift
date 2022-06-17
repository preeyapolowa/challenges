//
//  StoreAndProductsInteractor.swift
//  OpnChallenge

import UIKit

protocol StoreAndProductsInteractorOutput: AnyObject {
    func getStoreInfo(request: StoreAndProductsModels.GetStoreInfo.Request)
    func getProducts(request: StoreAndProductsModels.GetProducts.Request)
}

final class StoreAndProductsInteractor: StoreAndProductsInteractorOutput {
    var presenter: StoreAndProductsPresenterOutput!
    var worker = Worker(store: Store())
    
    // MARK: - Business logic
    func getStoreInfo(request: StoreAndProductsModels.GetStoreInfo.Request) {
        worker.getStoreInfo { [weak self] datas in
            guard let self = self else { return }
            let response = StoreAndProductsModels.GetStoreInfo.Response(data: datas)
            self.presenter.presentStoreInfo(response: response)
        }
    }
    
    func getProducts(request: StoreAndProductsModels.GetProducts.Request) {
        worker.getProducts { [weak self] datas in
            guard let self = self else { return }
            let response = StoreAndProductsModels.GetProducts.Response(data: datas)
            self.presenter.presentProducts(response: response)
        }
    }
}
