//
//  SideBarContentTableCell.swift
//  TPV
//
//  Created by Pablo Ceacero on 15/5/24.
//

import UIKit

protocol SideBarContentTableCellDelegate: AnyObject {
    func billRowDidChange(_ billRow: BillRow)
}

class SideBarContentTableCell: UITableViewCell {

    // Properties

    private var delegate: SideBarContentTableCellDelegate?
    private var billRow: BillRow!

    // Views

    private var infoStackView: UIStackView!
    private var nameLabel: UILabel!
    private var quantitySelector: QuantitySelectorView!
    private var quantityPaidSeparatorView: UIView!
    private var paidStackView: UIStackView!
    private var paidLabel: UILabel!
    private var paidPriceLabel: UILabel!
    private var paidOrderedSeparatorView: UIView!
    private var orderedStackView: UIStackView!
    private var orderedLabel: UILabel!
    private var orderedPriceLabel: UILabel!
    private var orderedTotalSeparatorView: UIView!
    private var totalLabel: UILabel!

    // Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        infoStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        
        paidStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        orderedStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        infoStackView.removeFromSuperview()
        nameLabel.removeFromSuperview()
        quantitySelector.removeFromSuperview()
        quantityPaidSeparatorView.removeFromSuperview()
        paidStackView.removeFromSuperview()
        paidLabel.removeFromSuperview()
        paidOrderedSeparatorView.removeFromSuperview()
        orderedStackView.removeFromSuperview()
        orderedLabel.removeFromSuperview()
        orderedPriceLabel.removeFromSuperview()
        orderedTotalSeparatorView.removeFromSuperview()
        totalLabel.removeFromSuperview()

        billRow = nil
        infoStackView = nil
        nameLabel = nil
        quantitySelector = nil
        quantityPaidSeparatorView = nil
        paidStackView = nil
        paidLabel = nil
        paidPriceLabel = nil
        paidOrderedSeparatorView = nil
        orderedStackView = nil
        orderedLabel = nil
        orderedPriceLabel = nil
        orderedTotalSeparatorView = nil
        totalLabel = nil
    }

    // MARK: - Functions

    func show(for billRow: BillRow) {
        self.billRow = billRow
        setupView()
    }

    func setAsDelegate(of delegate: SideBarContentTableCellDelegate) {
        self.delegate = delegate
    }

    private func updateLabels() {
        paidLabel.setTextWithFadeAnimation(billRow.paidQuantity.description)
        paidPriceLabel.setTextWithFadeAnimation(billRow.paidPrice.toCurrency())
        orderedLabel.setTextWithFadeAnimation(billRow.orderedQuantity.description)
        orderedPriceLabel.setTextWithFadeAnimation(billRow.orderedPrice.toCurrency())
        totalLabel.setTextWithFadeAnimation(billRow.orderedPrice.toCurrency())
    }

    // MARK: - Setup

    func setupView() {
        selectionStyle = .none
        setupInfoStackView()
        setupNameLabel()
        setupQuantitySelector()
        setupQuantityPaidSeparatorView()
        setupPaidStackView()
        setupPaidLabel()
        setupPaidPriceLabel()
        setupPaidOrderedSeparatorView()
        setupOrderedStackView()
        setupOrderedLabel()
        setupOrderedPriceLabel()
        setupOrderedTotalSeparatorView()
        setupTotalLabel()
    }
    
    func setupInfoStackView() {
        infoStackView = UIStackView()
        addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        setupInfoStackViewConstraints()
    }

    func setupNameLabel() {
        nameLabel = UILabel()
        infoStackView.addArrangedSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.text = billRow.item.name
        nameLabel.adjustsFontSizeToFitWidth = true
    }

    func setupQuantitySelector() {
        quantitySelector = QuantitySelectorView()
        addSubview(quantitySelector)
        quantitySelector.translatesAutoresizingMaskIntoConstraints = false
        quantitySelector.delegate = self
        quantitySelector.show(billRow.pendingQuantity)
        setupQuantitySelectorConstraints()
    }

    func setupQuantityPaidSeparatorView() {
        quantityPaidSeparatorView = UIView()
        addSubview(quantityPaidSeparatorView)
        quantityPaidSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        quantityPaidSeparatorView.backgroundColor = .systemGray4
        setupQuantityPaidSeparatorViewConstraints()
    }

    func setupPaidStackView() {
        paidStackView = UIStackView()
        addSubview(paidStackView)
        paidStackView.translatesAutoresizingMaskIntoConstraints = false
        paidStackView.axis = .vertical
        paidStackView.distribution = .fillProportionally
        setupPaidStackViewConstraints()
    }

    func setupPaidLabel() {
        paidLabel = UILabel()
        paidStackView.addArrangedSubview(paidLabel)
        paidLabel.translatesAutoresizingMaskIntoConstraints = false
        paidLabel.text = billRow.paidQuantity.description
        paidLabel.textAlignment = .center
        paidLabel.textColor = .darkGray
        paidLabel.font = UIFont.systemFont(ofSize: 24)
        paidLabel.adjustsFontSizeToFitWidth = true
    }

    func setupPaidPriceLabel() {
        paidPriceLabel = UILabel()
        paidStackView.addArrangedSubview(paidPriceLabel)
        paidPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        paidPriceLabel.text = billRow.paidPrice.toCurrency()
        paidPriceLabel.textAlignment = .center
        paidPriceLabel.textColor = .lightGray
        paidPriceLabel.font = UIFont.systemFont(ofSize: 14)
        paidPriceLabel.adjustsFontSizeToFitWidth = true
    }

    func setupPaidOrderedSeparatorView() {
        paidOrderedSeparatorView = UIView()
        addSubview(paidOrderedSeparatorView)
        paidOrderedSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        paidOrderedSeparatorView.backgroundColor = .systemGray4
        setupPaidOrderedSeparatorViewConstraints()
    }

    func setupOrderedStackView() {
        orderedStackView = UIStackView()
        addSubview(orderedStackView)
        orderedStackView.translatesAutoresizingMaskIntoConstraints = false
        orderedStackView.axis = .vertical
        orderedStackView.distribution = .fillProportionally
        setupOrderedStackViewConstraints()
    }

    func setupOrderedLabel() {
        orderedLabel = UILabel()
        orderedStackView.addArrangedSubview(orderedLabel)
        orderedLabel.translatesAutoresizingMaskIntoConstraints = false
        orderedLabel.text = billRow.orderedQuantity.description
        orderedLabel.textAlignment = .center
        orderedLabel.textColor = .darkGray
        orderedLabel.font = UIFont.systemFont(ofSize: 24)
        orderedLabel.adjustsFontSizeToFitWidth = true
    }

    func setupOrderedPriceLabel() {
        orderedPriceLabel = UILabel()
        orderedStackView.addArrangedSubview(orderedPriceLabel)
        orderedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        orderedPriceLabel.text = billRow.orderedPrice.toCurrency()
        orderedPriceLabel.textAlignment = .center
        orderedPriceLabel.textColor = .lightGray
        orderedPriceLabel.font = UIFont.systemFont(ofSize: 14)
        orderedPriceLabel.adjustsFontSizeToFitWidth = true
    }

    func setupOrderedTotalSeparatorView() {
        orderedTotalSeparatorView = UIView()
        addSubview(orderedTotalSeparatorView)
        orderedTotalSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        orderedTotalSeparatorView.backgroundColor = .systemGray4
        setupOrderedTotalSeparatorViewConstraints()
    }

    func setupTotalLabel() {
        totalLabel = UILabel()
        addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.text = billRow.orderedPrice.toCurrency()
        totalLabel.textAlignment = .center
        totalLabel.textColor = .darkGray
        totalLabel.font = UIFont.systemFont(ofSize: 20)
        totalLabel.adjustsFontSizeToFitWidth = true
        setupTotalLabelConstraints()
    }

    func setupInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 20),
            infoStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                 multiplier: 1 / 3),
        ])
    }

    func setupQuantitySelectorConstraints() {
        NSLayoutConstraint.activate([
            quantitySelector.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantitySelector.leadingAnchor.constraint(equalTo: infoStackView.trailingAnchor, constant: 40),
            quantitySelector.widthAnchor.constraint(equalTo: widthAnchor,
                                                    multiplier: 1 / 4)
        ])
    }

    func setupQuantityPaidSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            quantityPaidSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityPaidSeparatorView.leadingAnchor.constraint(equalTo: quantitySelector.trailingAnchor,
                                                               constant: 5),
            quantityPaidSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            quantityPaidSeparatorView.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
        ])
    }

    func setupPaidStackViewConstraints() {
        NSLayoutConstraint.activate([
            paidStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            paidStackView.leadingAnchor.constraint(equalTo: quantityPaidSeparatorView.trailingAnchor,
                                               constant: 5),
            paidStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: 1 / 10)
        ])
    }

    func setupPaidOrderedSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            paidOrderedSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            paidOrderedSeparatorView.leadingAnchor.constraint(equalTo: paidLabel.trailingAnchor,
                                                               constant: 5),
            paidOrderedSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            paidOrderedSeparatorView.heightAnchor.constraint(equalTo: heightAnchor, 
                                                             constant: -20),
        ])
    }

    func setupOrderedStackViewConstraints() {
        NSLayoutConstraint.activate([
            orderedStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderedStackView.leadingAnchor.constraint(equalTo: paidOrderedSeparatorView.trailingAnchor,
                                                  constant: 5),
            orderedStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: 1 / 10)
        ])
    }

    func setupOrderedTotalSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            orderedTotalSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderedTotalSeparatorView.leadingAnchor.constraint(equalTo: orderedStackView.trailingAnchor,
                                                               constant: 5),
            orderedTotalSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            orderedTotalSeparatorView.heightAnchor.constraint(equalTo: heightAnchor,
                                                              constant: -20),
        ])
    }

    func setupTotalLabelConstraints() {
        NSLayoutConstraint.activate([
            totalLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: orderedTotalSeparatorView.trailingAnchor,
                                                constant: 5),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -5)
        ])
    }
}


extension SideBarContentTableCell: QuantitySelectorDelegate {
    func quantityDidChange(_ quantitySelector: QuantitySelectorView, to quantity: Int) {
        billRow.orderedQuantity = self.quantitySelector.id == quantitySelector.id ?
            quantity + billRow.paidQuantity :
            billRow.orderedQuantity

        updateLabels()
        delegate?.billRowDidChange(billRow)
    }
}
