//
//  UIView.swift
//  TPV
//
//  Created by Pablo Ceacero on 17/5/24.
//

import UIKit

extension UILabel {
    func setTextWithFadeAnimation(_ text: String) {
        UIView.transition(with: self,
                          duration: 0.15,
                          options: [.transitionCrossDissolve],
                          animations: { [weak self] in
            guard let self else { return }
            self.text = text
        })
    }
}
