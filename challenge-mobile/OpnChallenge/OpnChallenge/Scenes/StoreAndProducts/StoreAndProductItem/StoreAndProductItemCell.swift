//
//  StoreAndProductItemCell.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 14/6/2565 BE.
//

import UIKit

struct StoreAndProductItemCellModel {
    let title: String
    let price: Int
    let isFav: Bool
    let amount: Int
    let imagePath: String
}

protocol StoreAndProductItemCellDelegate: AnyObject {
    func storeAndProductItemCell(didTapIncreaseAndDecrease cell: UITableViewCell, amount: Int)
    func storeAndProductItemCell(didTapFav cell: UITableViewCell, isFav: Bool)
}

class StoreAndProductItemCell: UITableViewCell {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    weak var delegate: StoreAndProductItemCellDelegate?
    private let favImage = UIImage(named: "icon_fav")
    private let unFavImage = UIImage(named: "icon_unfav")
    private var isFav = false
    private var amount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        addItemView.layer.borderWidth = 1
        addItemView.layer.borderColor = UIColor(hex: "#ECF0FE").cgColor
        addItemView.setRadius(radius: 10)
        detailView.setRadius(radius: frame.size.height * 0.18)
        detailImage.setRadius(radius: detailImage.frame.height / 2)
        favButton.setImage(unFavImage, for: .normal)
        DispatchQueue.main.async {
            self.detailView.dropShadow(edge: .all)
        }
        amountLabel.text = "0"
    }
    
    func updateUI(model: StoreAndProductItemCellModel) {
        titleLabel.text = model.title
        priceLabel.text = "\(model.price) Bath"
        amountLabel.text = "\(model.amount)"
        amount = model.amount
        isFav = model.isFav
        if let url = URL(string: model.imagePath) {
            detailImage.downloadImage(from: url)
        }
        if isFav {
            favButton.setImage(favImage, for: .normal)
        } else {
            favButton.setImage(unFavImage, for: .normal)
        }
    }
    
    @IBAction private func didTapFavButton() {
        isFav = !isFav
        if isFav {
            favButton.setImage(favImage, for: .normal)
        } else {
            favButton.setImage(unFavImage, for: .normal)
        }
        delegate?.storeAndProductItemCell(didTapFav: self, isFav: isFav)
    }
    
    @IBAction private func didTapIncreaseButton() {
        amount += 1
        delegate?.storeAndProductItemCell(didTapIncreaseAndDecrease: self, amount: amount)
    }
    
    @IBAction private func didTapDecreaseButton() {
        amount -= 1
        if amount < 0 {
            amount = 0
        }
        delegate?.storeAndProductItemCell(didTapIncreaseAndDecrease: self, amount: amount)
    }
}
