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
    weak var delegate: QuantitySelectorDelegate?
    private var quantity: Int = 0
    private var maxQuantity: Int = .max
    private var minQuantity: Int = 0

    // Views
    let id = UUID()
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
    func minusButtonTapped() {
        if quantity > minQuantity {
            quantity -= 1
            quantityLabel.setTextWithFadeAnimation(quantity.description)
            delegate?.quantityDidChange(self, to: quantity)
        }
    }

    @objc
    func plusButtonTapped() {
        if quantity < maxQuantity {
            quantity += 1
            quantityLabel.setTextWithFadeAnimation(quantity.description)
            delegate?.quantityDidChange(self, to: quantity)
        }
    }

    // Setup

    func setupViews() {
        setupContentStackView()
        setupMinusButton()
        setupQuantityLabel()
        setupPlusButton()
    }

    func setupContentStackView() {
        contentStackView = UIStackView()
        addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = 10
        contentStackView.distribution = .fillEqually
        setupContentStackViewConstraints()
    }

    func setupMinusButton() {
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
                              for: .touchUpInside)
        setupMinusButtonConstraints()
    }

    func setupQuantityLabel() {
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

    func setupPlusButton() {
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
                             for: .touchUpInside)
        setupPlusButtonConstraints()
    }

    func setupContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setupMinusButtonConstraints() {
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            minusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupQuantityLabelConstraints() {
        NSLayoutConstraint.activate([
            quantityLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupPlusButtonConstraints() {
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
