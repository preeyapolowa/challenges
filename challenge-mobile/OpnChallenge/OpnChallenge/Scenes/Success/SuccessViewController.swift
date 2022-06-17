//
//  SuccessViewController.swift
//  OpnChallenge

import UIKit

protocol SuccessViewControllerOutput: AnyObject {
}

final class SuccessViewController: UIViewController {
    @IBOutlet weak var backToHomeButton: UIButton!
    
    var interactor: SuccessInteractorOutput!
    var router: SuccessRouterInput!

    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let router = SuccessRouter()
        router.viewController = self

        let presenter = SuccessPresenter()
        presenter.viewController = self

        let interactor = SuccessInteractor()
        interactor.presenter = presenter

        self.interactor = interactor
        self.router = router
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        backToHomeButton.setRadius(radius: 30)
    }
    
    // MARK: - SetupViews

    // MARK: - Event handling

    // MARK: - Actions
    @IBAction private func didTapBackToHome() {
        navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("HandlePopToRootView"), object: nil)
    }
    
    // MARK: - Private func
}

// MARK: - Display logic

extension SuccessViewController: SuccessViewControllerOutput {
    
}

// MARK: - Start Any Extensions
