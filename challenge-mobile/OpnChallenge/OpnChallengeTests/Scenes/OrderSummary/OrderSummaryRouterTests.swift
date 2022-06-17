//
//  OrderSummaryRouterTests.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import XCTest
@testable import OpnChallenge

class OrderSummaryRouterTests: XCTestCase {
    private var router: OrderSummaryRouter!
    private var viewController: OrderSummaryViewController!
    private var navigationController: UINavigationControllerSpy!

    override func setUp() {
        super.setUp()
        setupOrderSummaryRouterTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupOrderSummaryRouterTests() {
        router = OrderSummaryRouter()
        viewController = OrderSummaryViewController()
        navigationController = UINavigationControllerSpy(rootViewController: viewController)
        router.viewController = viewController
    }
    
    func testNavigateBack() {
        // When
        router.navigateBack()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertTrue(self.navigationController.popViewControllerCalled, "router should call popViewController")
            XCTAssertEqual(self.navigationController.viewControllers.count, 1)
            if let destination = self.navigationController.viewControllers.last {
                XCTAssertTrue(destination is OrderSummaryViewController)
            } else {
                XCTFail("Should pop viewController to OrderSummaryViewController")
            }
        }
    }
    
    func testNavigateSuccess() {
        // When
        router.navigateToSuccess()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertTrue(self.navigationController.pushViewControllerCalled, "router should call pushViewController")
            XCTAssertEqual(self.navigationController.viewControllers.count, 2)
            if let destination = self.navigationController.viewControllers.last {
                XCTAssertTrue(destination is SuccessViewController)
            } else {
                XCTFail("Should push viewController to SuccessViewController")
            }
        }
    }
}
