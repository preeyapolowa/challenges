//
//  ResponsModel.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 14/6/2565 BE.
//

import Foundation

struct ErrorModel: Error, Codable {
    let title: String
    let description: String
    
    init(title: String,
         description: String) {
        self.title = title
        self.description = description
    }
}

struct StoreInfoModel: Codable {
    let name: String
    let rating: Double
    let openingTime: String
    let closingTime: String
    
    init(name: String,
         rating: Double,
         openingTime: String,
         closingTime: String) {
        self.name = name
        self.rating = rating
        self.openingTime = openingTime
        self.closingTime = closingTime
    }
}

struct ProductsModel: Codable {
    let name: String
    let price: Int
    let imageUrl: String
    var isFav: Bool?
    var amount: Int?
    
    init(name: String,
         price: Int,
         imageUrl: String) {
        self.name = name
        self.price = price
        self.imageUrl = imageUrl
        self.isFav = false
        self.amount = 0
    }
}

struct MakeOrderRequestModel: Encodable {
    let products: [ProductsModel]
    let deliveryAddress: String
}
