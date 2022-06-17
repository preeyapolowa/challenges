//
//  OrderSummaryPresenterTests.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import XCTest
@testable import OpnChallenge

class OrderSummaryPresenterTests: XCTestCase {
    private var presenter: OrderSummaryPresenter!
    private var viewControllerSpy: OrderSummaryPresenterSpy!
    
    override func setUp() {
        super.setUp()
        setupOrderSummaryPresenterTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupOrderSummaryPresenterTests() {
        presenter = OrderSummaryPresenter()
        let viewControllerSpy = OrderSummaryPresenterSpy()
        self.viewControllerSpy = viewControllerSpy
        presenter.viewController = viewControllerSpy
    }
    
    final class OrderSummaryPresenterSpy: OrderSummaryViewControllerOutput {
        var displayMakeOrderCalled = false
        
        var displayMakeOrderViewModel: OrderSummaryModels.MakeOrder.ViewModel!
        
        func displayMakeOrder(viewModel: OrderSummaryModels.MakeOrder.ViewModel) {
            displayMakeOrderCalled = true
            displayMakeOrderViewModel = viewModel
        }
    }
    
    func testPresentMakeOrder() {
        // Given
        let response = OrderSummaryModels.MakeOrder.Response()
        
        // When
        presenter.presentMakeOrder(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayMakeOrderCalled, "presenter should call viewController to displayMakeOrder")
    }
}
