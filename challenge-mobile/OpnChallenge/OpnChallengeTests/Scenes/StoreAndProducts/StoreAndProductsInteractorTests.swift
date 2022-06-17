//
//  StoreAndProducsInteractor.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import XCTest
@testable import OpnChallenge

class StoreAndProducsInteractorTests: XCTestCase {
    private var interactor: StoreAndProductsInteractor!
    private var presenterSpy: StoreAndProductsPresenterSpy!
    private var mockWorker: MockWorker!
    
    override func setUp() {
        super.setUp()
        setupStoreAndProductsInteractorTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupStoreAndProductsInteractorTests() {
        interactor = StoreAndProductsInteractor()
        presenterSpy = StoreAndProductsPresenterSpy()
        interactor.presenter = presenterSpy
        let mockWorker = MockWorker(store: MockStore())
        interactor.worker = mockWorker
        self.mockWorker = mockWorker
    }
    
    final class StoreAndProductsPresenterSpy: StoreAndProductsPresenterOutput {
        var presentStoreInfoCalled = false
        var presentProductsCalled = false
        
        var presentStoreInfoResponse: StoreAndProductsModels.GetStoreInfo.Response!
        var presentProductsResponse: StoreAndProductsModels.GetProducts.Response!
        
        func presentStoreInfo(response: StoreAndProductsModels.GetStoreInfo.Response) {
            presentStoreInfoCalled = true
            presentStoreInfoResponse = response
        }
        
        func presentProducts(response: StoreAndProductsModels.GetProducts.Response) {
            presentProductsCalled = true
            presentProductsResponse = response
        }
    }
    
    final class MockWorker: Worker {
        var forceFailure = false
        
        var getStoreInfoCalled = false
        var getProductsCalled = false
        var makeOrderCalled = false
        
        let errorModel = ErrorModel(title: "ErrorTitle", description: "ErrorDescription")
        
        override func getStoreInfo(_ completion: @escaping (Result<StoreInfoModel, ErrorModel>) -> Void) {
            getStoreInfoCalled = true
            if forceFailure {
                completion(.failure(errorModel))
            } else {
                super.getStoreInfo(completion)
            }
        }
        
        override func getProducts(_ completion: @escaping (Result<[ProductsModel], ErrorModel>) -> Void) {
            getProductsCalled = true
            if forceFailure {
                completion(.failure(errorModel))
            } else {
                super.getProducts(completion)
            }
        }
    }
    
    // MARK: GetStoreInfo Tests
    
    func testGetStoreInfoSuccess() {
        // Given
        let request = StoreAndProductsModels.GetStoreInfo.Request()
        
        // When
        interactor.getStoreInfo(request: request)
        
        // Then
        let response = presenterSpy.presentStoreInfoResponse.data
        switch response {
        case .success(let data):
            XCTAssertEqual(data.name, "Coffee Shop")
            XCTAssertEqual(data.rating, 4.5)
            XCTAssertEqual(data.openingTime, "8.00")
            XCTAssertEqual(data.closingTime, "17.00")
        case .failure:
            XCTFail("response should not error")
        }
        XCTAssertTrue(mockWorker.getStoreInfoCalled, "interactor should call worker to getStoreInfo()")
        XCTAssertTrue(presenterSpy.presentStoreInfoCalled, "interactor should call presenter to presentStoreInfo()")
    }
    
    func testGetStoreInfoFailed() {
        // Given
        let request = StoreAndProductsModels.GetStoreInfo.Request()
        mockWorker.forceFailure = true
        
        // When
        interactor.getStoreInfo(request: request)
        
        // Then
        let response = presenterSpy.presentStoreInfoResponse.data
        switch response {
        case .success:
            XCTFail("response should not success")
        case .failure(let error):
            XCTAssertEqual(error.title, "ErrorTitle")
            XCTAssertEqual(error.description, "ErrorDescription")
        }
        XCTAssertTrue(mockWorker.getStoreInfoCalled, "interactor should call worker to getStoreInfo()")
        XCTAssertTrue(presenterSpy.presentStoreInfoCalled, "interactor should call presenter to presentStoreInfo()")
    }
    
    // MARK: GetProducts Tests
    
    func testGetProductsSuccess() {
        // Given
        let request = StoreAndProductsModels.GetProducts.Request()
        
        // When
        interactor.getProducts(request: request)
        
        // Then
        let response = presenterSpy.presentProductsResponse.data
        switch response {
        case .success(let data):
            if let firstData = data.first {
                XCTAssertEqual(firstData.name, "Matcha")
                XCTAssertEqual(firstData.price, 50)
                XCTAssertEqual(firstData.imageUrl, "imageUrl")
                XCTAssertFalse(firstData.isFav ?? true)
                XCTAssertEqual(firstData.amount, 0)
            } else {
                XCTFail("First data is empty")
            }
        case .failure:
            XCTFail("response should not error")
        }
        XCTAssertTrue(mockWorker.getProductsCalled, "interactor should call worker to getProducts()")
        XCTAssertTrue(presenterSpy.presentProductsCalled, "interactor should call presenter to presentProducts()")
    }
    
    func testGetProductsFailed() {
        // Given
        let request = StoreAndProductsModels.GetProducts.Request()
        mockWorker.forceFailure = true
        
        // When
        interactor.getProducts(request: request)
        
        // Then
        let response = presenterSpy.presentProductsResponse.data
        switch response {
        case .success:
            XCTFail("response should not success")
        case .failure(let error):
            XCTAssertEqual(error.title, "ErrorTitle")
            XCTAssertEqual(error.description, "ErrorDescription")
        }
        XCTAssertTrue(mockWorker.getProductsCalled, "interactor should call worker to getProducts()")
        XCTAssertTrue(presenterSpy.presentProductsCalled, "interactor should call presenter to presentProducts()")
    }
}
