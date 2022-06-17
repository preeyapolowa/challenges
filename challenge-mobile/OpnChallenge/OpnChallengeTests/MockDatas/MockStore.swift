//
//  MockStore.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

@testable import OpnChallenge

class MockStore: StoreProtocol {
    func getStoreInfo(_ completion: @escaping (Result<StoreInfoModel, ErrorModel>) -> Void) {
        let model = StoreInfoModel(name: "Coffee Shop", rating: 4.5, openingTime: "8.00", closingTime: "17.00")
        completion(.success(model))
    }
    
    func getProducts(_ completion: @escaping (Result<[ProductsModel], ErrorModel>) -> Void) {
        let productModel1 = ProductsModel(name: "Matcha", price: 50, imageUrl: "imageUrl")
        let productModel2 = ProductsModel(name: "CoCo", price: 150, imageUrl: "imageUrl")
        let model = [productModel1, productModel2]
        completion(.success(model))
    }
    
    func makeOrder(request: MakeOrderRequestModel) { }
}
