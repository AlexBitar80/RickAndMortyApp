//
//  UIView + Extensions.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 23/01/23.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
