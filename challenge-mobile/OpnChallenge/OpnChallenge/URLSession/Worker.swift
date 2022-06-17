//
//  Worker.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 14/6/2565 BE.
//

import Foundation

protocol StoreProtocol {
    func getStoreInfo(_ completion: @escaping (Result<StoreInfoModel, ErrorModel>) -> Void)
    func getProducts(_ completion: @escaping (Result<[ProductsModel], ErrorModel>) -> Void)
    func makeOrder(request: MakeOrderRequestModel)
}

class Worker {
    let store: StoreProtocol
    init(store: StoreProtocol) {
        self.store = store
    }
    
    func getStoreInfo(_ completion: @escaping (Result<StoreInfoModel, ErrorModel>) -> Void) {
        store.getStoreInfo(completion)
    }
    
    func getProducts(_ completion: @escaping (Result<[ProductsModel], ErrorModel>) -> Void) {
        store.getProducts(completion)
    }
    
    func makeOrder(request: MakeOrderRequestModel) {
        store.makeOrder(request: request)
    }
}
