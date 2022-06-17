//
//  Store.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 14/6/2565 BE.
//

import Foundation

class Store: StoreProtocol {
    private let domainName = "https://c8d92d0a-6233-4ef7-a229-5a91deb91ea1.mock.pstmn.io/"
    private let errorInvalidURLModel = ErrorModel(title: "URL is invalid",
                                                  description: "Please check your Url")
    private let errorInvalidData = ErrorModel(title: "Could not load data",
                                              description: "Please check your model response")
    
    enum Endpoints: String {
        case storeinfo = "storeInfo"
        case products = "products"
        case makeOrder = "order"
    }
    
    func getStoreInfo(_ completion: @escaping (Result<StoreInfoModel, ErrorModel>) -> Void) {
        let fullPath = "\(domainName)\(Endpoints.storeinfo.rawValue)"
        if let url = URL(string: fullPath) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let dataValid = data {
                    do {
                        let storeInfoResponse = try JSONDecoder().decode(StoreInfoModel.self, from: dataValid)
                        guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                            completion(.failure(self.errorInvalidData))
                            return
                        }
                        
                        guard 200 ..< 300 ~= httpResponse.statusCode else {
                            let errorModel = ErrorModel(title: "Error HTTP Status code",
                                                        description: "Status code was \(httpResponse.statusCode), but expected 2xx")
                            completion(.failure(errorModel))
                            return
                        }
                        
                        DispatchQueue.main.async {
                            completion(.success(storeInfoResponse))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(self.errorInvalidData))
                        }
                    }
                } else {
                    completion(.failure(self.errorInvalidData))
                }
            }.resume()
        } else {
            completion(.failure(errorInvalidURLModel))
        }
    }
    
    func getProducts(_ completion: @escaping (Result<[ProductsModel], ErrorModel>) -> Void) {
        let fullPath = "\(domainName)\(Endpoints.products.rawValue)"
        if let url = URL(string: fullPath) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let dataValid = data {
                    do {
                        let productsResponse = try JSONDecoder().decode([ProductsModel].self, from: dataValid)
                        guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                            completion(.failure(self.errorInvalidData))
                            return
                        }
                        
                        guard 200 ..< 505 ~= httpResponse.statusCode else {
                            let errorModel = ErrorModel(title: "Error HTTP Status code",
                                                        description: "Status code was \(httpResponse.statusCode), but expected 2xx")
                            completion(.failure(errorModel))
                            return
                        }
                        
                        DispatchQueue.main.async {
                            completion(.success(productsResponse))
                        }
                    } catch let error {
                        print(error)
                        DispatchQueue.main.async {
                            completion(.failure(self.errorInvalidData))
                        }
                    }
                } else {
                    completion(.failure(self.errorInvalidData))
                }
            }.resume()
        } else {
            completion(.failure(errorInvalidURLModel))
        }
    }
    
    func makeOrder(request: MakeOrderRequestModel) {
        let fullPath = "\(domainName)\(Endpoints.makeOrder.rawValue)"
        if let url = URL(string: fullPath) {
            var requestAPI = URLRequest(url: url)
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let requestBody = try? encoder.encode(request)
            requestAPI.httpBody = requestBody
            requestAPI.httpMethod = "POST"
            URLSession.shared.dataTask(with: requestAPI) { (_, _, _) in }.resume()
        }
    }
}
