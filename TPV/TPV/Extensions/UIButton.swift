//
//  UIButton.swift
//  TPV
//
//  Created by Pablo Ceacero on 18/5/24.
//

import UIKit

extension UIButton {
    func setBackgroundColorWithFadeAnimation(_ color: UIColor) {
        UIView.transition(with: self,
                          duration: 0.15,
                          options: [.transitionCrossDissolve],
                          animations: { [weak self] in
            guard let self else { return }
            self.backgroundColor = color
        })
    }
}
