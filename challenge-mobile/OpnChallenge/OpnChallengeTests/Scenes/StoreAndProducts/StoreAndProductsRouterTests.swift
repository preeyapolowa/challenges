//
//  StoreAndProductsRouterTests.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import XCTest
@testable import OpnChallenge

class StoreAndProductsRouterTests: XCTestCase {
    private var router: StoreAndProductsRouter!
    private var viewController: StoreAndProductsViewController!
    private var navigationController: UINavigationControllerSpy!
    
    override func setUp() {
        super.setUp()
        setupStoreAndProductsRouterTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupStoreAndProductsRouterTests() {
        router = StoreAndProductsRouter()
        viewController = StoreAndProductsViewController()
        navigationController = UINavigationControllerSpy(rootViewController: viewController)
        router.viewController = viewController
    }
    
    func testNavigateToOrderSummary() {
        // Given
        let datas = [ProductsModel]()
        
        // When
        router.navigateToOrderSummary(datas: datas)
        
        // Then
        DispatchQueue.main.async {
            XCTAssertTrue(self.navigationController.pushViewControllerCalled, "router should call pushViewController")
            XCTAssertEqual(self.navigationController.viewControllers.count, 2)
            if let destination = self.navigationController.viewControllers.last as? OrderSummaryViewController {
                XCTAssertEqual(destination.interactor.datas.count, 0)
            } else {
                XCTFail("Should push viewController to StoreAndProductsViewController")
            }
        }
    }
}
