//
//  UIView.swift
//  TPV
//
//  Created by Pablo Ceacero on 17/5/24.
//

import UIKit

extension UIView {
    func hideIf(_ hide: Bool) {
        if hide {
            hideWithAnimation()
        } else {
            showWithAnimation()
        }
    }

    func hideWithAnimation() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self else { return }
            self.alpha = 0
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.isHidden = true
        })
    }

    func showWithAnimation() {
        self.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            self.alpha = 1
        }
    }
}
