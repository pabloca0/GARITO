//
//  QuantitySelectorView.swift
//  TPV
//
//  Created by Pablo Ceacero on 15/5/24.
//

import UIKit

protocol QuantitySelectorDelegate: AnyObject {
    func quantityDidChange(_ quantitySelector: QuantitySelectorView, to quantity: Int)
}

class QuantitySelectorView: UIView {

    // Properties

    let id = UUID()
    weak var delegate: QuantitySelectorDelegate?
    private var quantity: Int = 0
    private var maxQuantity: Int = .max
    private var minQuantity: Int = 0
    private var incrementTimer: Timer?

    // Views

    private var contentStackView: UIStackView!
    private var minusButton: UIButton!
    private var plusButton: UIButton!
    private var quantityLabel: UILabel!

    // Functions

    func show(_ quantity: Int?, maxQuantity: Int? = .max, minQuantity: Int? = 0) {
        self.quantity = quantity ?? 0
        self.maxQuantity = maxQuantity ?? .max
        self.minQuantity = minQuantity ?? 0
        setupViews()
    }

    @objc
    private func incrementQuantity() {
        if quantity < maxQuantity {
            quantity += 1
            quantityLabel.setTextWithFadeAnimation(quantity.description)
            delegate?.quantityDidChange(self, to: quantity)
        }
    }

    @objc
    private func decrementQuantity() {
        if quantity > minQuantity {
            quantity -= 1
            quantityLabel.setTextWithFadeAnimation(quantity.description)
            delegate?.quantityDidChange(self, to: quantity)
        }
    }

    @objc
    private func minusButtonTapped() {
        decrementQuantity()
        incrementTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(decrementQuantity),
                                              userInfo: nil,
                                              repeats: true)
    }

    @objc
    private func plusButtonTapped() {
        incrementQuantity()
        incrementTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(incrementQuantity),
                                              userInfo: nil,
                                              repeats: true)
    }

    @objc
    private func buttonReleased() {
        incrementTimer?.invalidate()
        incrementTimer = nil
    }

    // Setup

    private func setupViews() {
        setupContentStackView()
        setupMinusButton()
        setupQuantityLabel()
        setupPlusButton()
    }

    private func setupContentStackView() {
        contentStackView = UIStackView()
        addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = 10
        contentStackView.distribution = .fillEqually
        setupContentStackViewConstraints()
    }

    private func setupMinusButton() {
        minusButton = UIButton()
        contentStackView.addArrangedSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.tintColor = UIColor(red: 187 / 255,
                                        green: 72 / 255,
                                        blue: 36 / 255, alpha: 1)
        minusButton.setImage(UIImage(systemName: "minus.circle.fill"),
                             for: .normal)
        minusButton.contentHorizontalAlignment = .fill
        minusButton.contentVerticalAlignment = .fill
        minusButton.imageView?.contentMode = .scaleAspectFit
        minusButton.addTarget(self,
                             action: #selector(minusButtonTapped),
                             for: .touchDown)
        minusButton.addTarget(self,
                             action: #selector(buttonReleased),
                             for: [.touchUpInside, .touchUpOutside, .touchCancel])
        setupMinusButtonConstraints()
    }

    private func setupQuantityLabel() {
        quantityLabel = UILabel()
        contentStackView.addArrangedSubview(quantityLabel)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.text = quantity.description
        quantityLabel.textAlignment = .center
        quantityLabel.textColor = .darkGray
        quantityLabel.font = UIFont.systemFont(ofSize: 24)
        quantityLabel.adjustsFontSizeToFitWidth = true
        setupQuantityLabelConstraints()
    }

    private func setupPlusButton() {
        plusButton = UIButton()
        contentStackView.addArrangedSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = UIColor(red: 71 / 255, green: 82 / 255, blue: 119 / 255, alpha: 1)
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"),
                            for: .normal)
        plusButton.contentHorizontalAlignment = .fill
        plusButton.contentVerticalAlignment = .fill
        plusButton.imageView?.contentMode = .scaleAspectFit
        plusButton.addTarget(self,
                             action: #selector(plusButtonTapped),
                             for: .touchDown)
        plusButton.addTarget(self,
                             action: #selector(buttonReleased), 
                             for: [.touchUpInside, .touchUpOutside, .touchCancel])
        setupPlusButtonConstraints()
    }

    private func setupContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupMinusButtonConstraints() {
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            minusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupQuantityLabelConstraints() {
        NSLayoutConstraint.activate([
            quantityLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupPlusButtonConstraints() {
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
