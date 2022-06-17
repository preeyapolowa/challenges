//
//  UIImageView+Extension.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 15/6/2565 BE.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
            }
        }
    }

    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
