//
//  StoreAndProductsViewController.swift
//  OpnChallenge

import UIKit

protocol StoreAndProductsViewControllerOutput: AnyObject {
    func displayStoreInfo(viewModel: StoreAndProductsModels.GetStoreInfo.ViewModel)
    func displayProducts(viewModel: StoreAndProductsModels.GetProducts.ViewModel)
}

final class StoreAndProductsViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var closeTime: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var interactor: StoreAndProductsInteractorOutput!
    var router: StoreAndProductsRouterInput!

    private let disableButtonColor = UIColor(hex: "#FFEDDB")
    private let enableButtonColor = UIColor(hex: "#864000")
    private var datas: [ProductsModel] = [ProductsModel]()
    private let refreshView = RefreshView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    
    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let router = StoreAndProductsRouter()
        router.viewController = self

        let presenter = StoreAndProductsPresenter()
        presenter.viewController = self

        let interactor = StoreAndProductsInteractor()
        interactor.presenter = presenter

        self.interactor = interactor
        self.router = router
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor.getStoreInfo(request: StoreAndProductsModels.GetStoreInfo.Request())
        interactor.getProducts(request: StoreAndProductsModels.GetProducts.Request())
    }
    
    // MARK: - SetupViews
    
    private func setupUI() {
        // TableView
        registerCell()
        tableView.setRadius(radius: 50)
        
        // RefreshView
        view.addSubview(refreshView)
        refreshView.center = view.convert(view.center, from: view.superview)
        refreshView.delegate = self
        
        // Setup
        contentView.setRadius(radius: 50, edge: .top)
        ratingView.setRadius(radius: ratingView.frame.height / 2)
        hideContent()
        
        // Loading
        loading.isHidden = false
        loading.startAnimating()
        
        // Place order button
        placeOrderButton.backgroundColor = disableButtonColor
        placeOrderButton.setRadius(radius: 30)
        placeOrderButton.isUserInteractionEnabled = false
        
        // NotificationCenter
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handlePopToRootView),
                                               name: Notification.Name(rawValue: "HandlePopToRootView"),
                                               object: nil)
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "StoreAndProductItemCell", bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Event handling

    // MARK: - Actions
    
    @IBAction private func didTapPlaceOrderButton() {
        router.navigateToOrderSummary(datas: datas)
    }
    
    // MARK: - Private func
    
    private func hideContent() {
        navView.isHidden = true
        contentView.isHidden = true
        ratingView.isHidden = true
        refreshView.isHidden = true
        loading.isHidden = true
        loading.stopAnimating()
    }
    
    private func showContent() {
        navView.isHidden = false
        contentView.isHidden = false
        ratingView.isHidden = false
        loading.isHidden = true
        loading.stopAnimating()
    }
    
    private func showRefreshView(title: String, description: String) {
        refreshView.isHidden = false
        refreshView.updateUI(title: title, description: description)
    }
    
    private func getIndexRow(cell: UITableViewCell) -> Int {
        if let index = tableView.indexPath(for: cell)?.row {
            return index
        }
        return 0
    }
    
    private func updatePlaceOrderButton() {
        placeOrderButton.backgroundColor = disableButtonColor
        placeOrderButton.isUserInteractionEnabled = false
        datas.forEach { products in
            if let amount = products.amount {
                if amount > 0 {
                    placeOrderButton.backgroundColor = enableButtonColor
                    placeOrderButton.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @objc private func handlePopToRootView() {
        setupUI()
        interactor.getStoreInfo(request: StoreAndProductsModels.GetStoreInfo.Request())
        interactor.getProducts(request: StoreAndProductsModels.GetProducts.Request())
    }
}

// MARK: - Display logic

extension StoreAndProductsViewController: StoreAndProductsViewControllerOutput {
    func displayStoreInfo(viewModel: StoreAndProductsModels.GetStoreInfo.ViewModel) {
        switch viewModel.data {
        case .success(let data):
            titleLabel.text = data.name
            openTime.text = data.openingTime.prefix(5).lowercased()
            closeTime.text = data.closingTime.prefix(5).lowercased()
            ratingLabel.text = "\(data.rating)"
        case .failure:
            break
        }
    }
    
    func displayProducts(viewModel: StoreAndProductsModels.GetProducts.ViewModel) {
        switch viewModel.data {
        case .success(let data):
            showContent()
            datas = data
            tableView.reloadData()
        case .failure(let error):
            hideContent()
            showRefreshView(title: error.title, description: error.description)
        }
    }
}

// MARK: - Start Any Extensions

extension StoreAndProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StoreAndProductItemCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let data = datas[indexPath.row]
        let model = StoreAndProductItemCellModel(title: data.name,
                                                 price: data.price,
                                                 isFav: data.isFav ?? false,
                                                 amount: data.amount ?? 0,
                                                 imagePath: data.imageUrl)
        cell.delegate = self
        cell.updateUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension StoreAndProductsViewController: UITableViewDelegate {
    
}

extension StoreAndProductsViewController: RefreshViewDelegate {
    func refreshView(didTapRefreshButton refreshView: UIView) {
        interactor.getStoreInfo(request: StoreAndProductsModels.GetStoreInfo.Request())
        interactor.getProducts(request: StoreAndProductsModels.GetProducts.Request())
    }
}

extension StoreAndProductsViewController: StoreAndProductItemCellDelegate {
    func storeAndProductItemCell(didTapFav cell: UITableViewCell, isFav: Bool) {
        let index = getIndexRow(cell: cell)
        datas[index].isFav = isFav
        tableView.reloadData()
        updatePlaceOrderButton()
    }
    
    func storeAndProductItemCell(didTapIncreaseAndDecrease cell: UITableViewCell, amount: Int) {
        let index = getIndexRow(cell: cell)
        datas[index].amount = amount
        tableView.reloadData()
        updatePlaceOrderButton()
    }
}
