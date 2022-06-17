//
//  StoreAndProductsModels.swift
//  OpnChallenge

import UIKit

struct StoreAndProductsModels {
    enum GetStoreInfo {
        struct Request { }
        struct Response {
            let data: Result<StoreInfoModel, ErrorModel>
        }
        
        struct ViewModel {
            let data: Result<StoreInfoModel, ErrorModel>
        }
    }
    
    enum GetProducts {
        struct Request {
            
        }
        
        struct Response {
            let data: Result<[ProductsModel], ErrorModel>
        }
        
        struct ViewModel {
            let data: Result<[ProductsModel], ErrorModel>
        }
    }
    
    enum MakeOrder {
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
}
