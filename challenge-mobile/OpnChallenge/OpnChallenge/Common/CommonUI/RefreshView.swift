//
//  RefreshView.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 15/6/2565 BE.
//

import Foundation
import UIKit

protocol RefreshViewDelegate: AnyObject {
    func refreshView(didTapRefreshButton refreshView: UIView)
}

class RefreshView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var contentView: UIView!
    weak var delegate: RefreshViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setRadius(radius: 50)
        refreshButton.setRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViewFromNib()
        setRadius(radius: 50)
        refreshButton.setRadius()
    }
    
    func updateUI(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    @IBAction private func didTapRefreshButton() {
        delegate?.refreshView(didTapRefreshButton: self)
    }
}

extension RefreshView {
    func loadViewFromNib() {
        let bundle = Bundle(for: RefreshView.self)
        contentView = UINib(nibName: String(describing: type(of: self)), bundle: bundle).instantiate(withOwner: self).first as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
}
