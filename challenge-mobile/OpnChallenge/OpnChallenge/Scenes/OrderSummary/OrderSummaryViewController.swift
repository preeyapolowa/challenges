//
//  OrderSummaryViewController.swift
//  OpnChallenge

import UIKit

protocol OrderSummaryViewControllerOutput: AnyObject {
    func displayMakeOrder(viewModel: OrderSummaryModels.MakeOrder.ViewModel)
}

final class OrderSummaryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var interactor: OrderSummaryInteractorOutput!
    var router: OrderSummaryRouterInput!

    private let disableButtonColor = UIColor(hex: "#FFEDDB")
    private let enableButtonColor = UIColor(hex: "#864000")
    
    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let router = OrderSummaryRouter()
        router.viewController = self

        let presenter = OrderSummaryPresenter()
        presenter.viewController = self

        let interactor = OrderSummaryInteractor()
        interactor.presenter = presenter

        self.interactor = interactor
        self.router = router
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - SetupViews
    
    private func setupUI() {
        registerCell()
        
        calculateAllPrice()
        
        // ConfirmButton order button
        confirmButton.backgroundColor = enableButtonColor
        confirmButton.setRadius(radius: 30)
        confirmButton.isUserInteractionEnabled = true
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "StoreAndProductItemCell", bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Event handling

    // MARK: - Actions
    @IBAction private func didTapBackButton() {
        router.navigateBack()
    }
    
    @IBAction private func didTapConfirmButton() {
        let model = MakeOrderRequestModel(products: interactor.datas, deliveryAddress: "Somewhere")
        let request = OrderSummaryModels.MakeOrder.Request(request: model)
        interactor.makeOrder(request: request)
    }
    
    // MARK: - Private func
    
    private func updatePlaceOrderButton() {
        confirmButton.backgroundColor = disableButtonColor
        confirmButton.isUserInteractionEnabled = false
        interactor.datas.forEach { products in
            if let amount = products.amount {
                if amount > 0 {
                    confirmButton.backgroundColor = enableButtonColor
                    confirmButton.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private func getIndexRow(cell: UITableViewCell) -> Int {
        if let index = tableView.indexPath(for: cell)?.row {
            return index
        }
        return 0
    }
    
    private func calculateAllPrice() {
        var price = 0
        interactor.datas.forEach { data in
            price += data.price * (data.amount ?? 0)
        }
        priceLabel.text = "\(price) ฿"
    }
}

// MARK: - Display logic

extension OrderSummaryViewController: OrderSummaryViewControllerOutput {
    func displayMakeOrder(viewModel: OrderSummaryModels.MakeOrder.ViewModel) {
        presentFullScreenLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true)
            self.router.navigateToSuccess()
        }
    }
}

// MARK: - Start Any Extensions

extension OrderSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StoreAndProductItemCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let data = interactor.datas[indexPath.row]
        let price = data.price * (data.amount ?? 0)
        let model = StoreAndProductItemCellModel(title: data.name,
                                                 price: price,
                                                 isFav: data.isFav ?? false,
                                                 amount: data.amount ?? 0,
                                                 imagePath: data.imageUrl)
        cell.delegate = self
        cell.updateUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension OrderSummaryViewController: UITableViewDelegate {
    
}

extension OrderSummaryViewController: StoreAndProductItemCellDelegate {
    func storeAndProductItemCell(didTapFav cell: UITableViewCell, isFav: Bool) {
        let index = getIndexRow(cell: cell)
        interactor.datas[index].isFav = isFav
        tableView.reloadData()
        updatePlaceOrderButton()
    }
    
    func storeAndProductItemCell(didTapIncreaseAndDecrease cell: UITableViewCell, amount: Int) {
        let index = getIndexRow(cell: cell)
        interactor.datas[index].amount = amount
        tableView.reloadData()
        calculateAllPrice()
        updatePlaceOrderButton()
    }
}
