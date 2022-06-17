//
//  UIView+Extension.swift
//  OpnChallenge
//
//  Created by Preeyapol Owatsuwan on 14/6/2565 BE.
//

import UIKit

enum AIEdge: Int {
    case
    top,
    left,
    bottom,
    right,
    topLeft,
    topRight,
    bottomLeft,
    bottomRight,
    all,
    none
}

extension UIView {
    func setRadius(radius: CGFloat = 8.0, edge: AIEdge = .all) {
        switch edge {
        case .top:
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        default:
            break
        }
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func dropShadow(edge: AIEdge, shadowSpace: CGFloat = 8) {
        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)
        case .topLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .topRight:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .bottomLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .bottomRight:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)
        case .all:
            sizeOffset = CGSize(width: 0, height: 0)
        case .none:
            sizeOffset = CGSize.zero
        }
        self.layer.shadowColor = UIColor(hex: "#BABABA").cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = 8.0
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
