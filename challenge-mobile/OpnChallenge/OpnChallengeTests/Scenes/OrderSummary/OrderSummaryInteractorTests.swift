//
//  OrderSummaryInteractorTests.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import XCTest
@testable import OpnChallenge

class OrderSummaryInteractorTests: XCTestCase {
    private var interactor: OrderSummaryInteractor!
    private var presenterSpy: OrderSummaryPresenterSpy!
    private var mockWorker: MockWorker!
    
    override func setUp() {
        super.setUp()
        setupOrderSummaryInteractorTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupOrderSummaryInteractorTests() {
        interactor = OrderSummaryInteractor()
        let presenterSpy = OrderSummaryPresenterSpy()
        self.presenterSpy = presenterSpy
        interactor.presenter = presenterSpy
        let mockWorker = MockWorker(store: MockStore())
        self.mockWorker = mockWorker
        interactor.worker = mockWorker
    }
    
    final class OrderSummaryPresenterSpy: OrderSummaryPresenterOutput {
        var presentMakeOrderCalled = false
        
        var presentMakeOrderResponse: OrderSummaryModels.MakeOrder.Response!

        func presentMakeOrder(response: OrderSummaryModels.MakeOrder.Response) {
            presentMakeOrderCalled = true
            presentMakeOrderResponse = response
        }
    }
    
    final class MockWorker: Worker {
        var makeOrderCalled = false
        
        override func makeOrder(request: MakeOrderRequestModel) {
            makeOrderCalled = true
        }
    }
    
    func testMakeOrder() {
        // Given
        let model = MakeOrderRequestModel(products: [ProductsModel](), deliveryAddress: "delivery address")
        let request = OrderSummaryModels.MakeOrder.Request(request: model)
        
        // When
        interactor.makeOrder(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentMakeOrderCalled, "interactor should call presenter to presentMakeOrder")
        XCTAssertTrue(mockWorker.makeOrderCalled, "interactor should call worker to makeOrder")
    }
}
