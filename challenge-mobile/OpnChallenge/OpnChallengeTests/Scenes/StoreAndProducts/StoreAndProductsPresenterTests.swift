//
//  StoreAndProductsPresenterTests.swift
//  OpnChallengeTests
//
//  Created by Preeyapol Owatsuwan on 17/6/2565 BE.
//

import XCTest
@testable import OpnChallenge

class StoreAndProductsPresenterTests: XCTestCase {
    private var presenter: StoreAndProductsPresenter!
    private var viewControllerSpy: StoreAndProductsViewControllerSpy!
    
    
    override func setUp() {
        super.setUp()
        setupStoreAndProductsPresenterTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupStoreAndProductsPresenterTests() {
        presenter = StoreAndProductsPresenter()
        let viewControllerSpy = StoreAndProductsViewControllerSpy()
        presenter.viewController = viewControllerSpy
        self.viewControllerSpy = viewControllerSpy
    }
    
    final class StoreAndProductsViewControllerSpy: StoreAndProductsViewControllerOutput {
        var displayStoreInfoCalled = false
        var displayProductsCalled = false
        
        var displayStoreInfoViewModel: StoreAndProductsModels.GetStoreInfo.ViewModel!
        var displayProductsViewModel: StoreAndProductsModels.GetProducts.ViewModel!
        
        func displayStoreInfo(viewModel: StoreAndProductsModels.GetStoreInfo.ViewModel) {
            displayStoreInfoCalled = true
            displayStoreInfoViewModel = viewModel
        }
        
        func displayProducts(viewModel: StoreAndProductsModels.GetProducts.ViewModel) {
            displayProductsCalled = true
            displayProductsViewModel = viewModel
        }
    }
    
    func testPresentStoreInfoSuccess() {
        // Given
        let model = StoreInfoModel(name: "Coffee Shop", rating: 4.5, openingTime: "8.00", closingTime: "17.00")
        let response = StoreAndProductsModels.GetStoreInfo.Response(data: .success(model))
        
        // When
        presenter.presentStoreInfo(response: response)
        
        // Then
        let viewModel = viewControllerSpy.displayStoreInfoViewModel.data
        switch viewModel {
        case .success(let data):
            XCTAssertEqual(data.name, "Coffee Shop")
            XCTAssertEqual(data.rating, 4.5)
            XCTAssertEqual(data.openingTime, "8.00")
            XCTAssertEqual(data.closingTime, "17.00")
        case .failure:
            XCTFail("viewModel should not error")
        }
        XCTAssertTrue(viewControllerSpy.displayStoreInfoCalled, "presenter should call viewController to displayStoreInfo")
    }
    
    func testPresentStoreInfoFailed() {
        // Given
        let errorModel = ErrorModel(title: "ErrorTitle", description: "ErrorDescription")
        let response = StoreAndProductsModels.GetStoreInfo.Response(data: .failure(errorModel))
        
        // When
        presenter.presentStoreInfo(response: response)
        
        // Then
        let viewModel = viewControllerSpy.displayStoreInfoViewModel.data
        switch viewModel {
        case .success:
            XCTFail("viewModel should not success")
        case .failure(let error):
            XCTAssertEqual(error.title, "ErrorTitle")
            XCTAssertEqual(error.description, "ErrorDescription")
        }
        XCTAssertTrue(viewControllerSpy.displayStoreInfoCalled, "presenter should call viewController to displayStoreInfo")
    }
}
