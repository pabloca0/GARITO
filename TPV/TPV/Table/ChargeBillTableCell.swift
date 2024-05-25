//
//  SideBarContentTableCell.swift
//  TPV
//
//  Created by Pablo Ceacero on 15/5/24.
//

import UIKit

protocol ChargeBillTableCellDelegate: AnyObject {
    func billRowDidChange(_ billRow: BillRow)
}

class ChargeBillTableCell: UITableViewCell {

    // Properties

    private var delegate: ChargeBillTableCellDelegate?
    private var billRow: BillRow!

    // Views

    private var infoStackView: UIStackView!
    private var nameLabel: UILabel!
    private var orderedStackView: UIStackView!
    private var orderedLabel: UILabel!
    private var orderedPriceLabel: UILabel!
    private var orderedQuantitySeparatorView: UIView!
    private var quantitySelector: QuantitySelectorView!
    private var quantityPendingSeparatorView: UIView!
    private var pendingStackView: UIStackView!
    private var pendingLabel: UILabel!
    private var pendingPriceLabel: UILabel!
    private var pendingTotalSeparatorView: UIView!
    private var totalLabel: UILabel!

    // Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        infoStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        orderedStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        pendingStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        infoStackView.removeFromSuperview()
        nameLabel.removeFromSuperview()
        quantitySelector.removeFromSuperview()
        orderedQuantitySeparatorView.removeFromSuperview()
        orderedStackView.removeFromSuperview()
        orderedLabel.removeFromSuperview()
        quantityPendingSeparatorView.removeFromSuperview()
        pendingStackView.removeFromSuperview()
        pendingLabel.removeFromSuperview()
        pendingPriceLabel.removeFromSuperview()
        pendingTotalSeparatorView.removeFromSuperview()
        totalLabel.removeFromSuperview()

        billRow = nil
        infoStackView = nil
        nameLabel = nil
        quantitySelector = nil
        orderedQuantitySeparatorView = nil
        orderedStackView = nil
        orderedLabel = nil
        orderedPriceLabel = nil
        quantityPendingSeparatorView = nil
        pendingStackView = nil
        pendingLabel = nil
        pendingPriceLabel = nil
        pendingTotalSeparatorView = nil
        totalLabel = nil
    }

    // Functions

    func show(for billRow: BillRow) {
        self.billRow = billRow
        setupView()
    }

    func setAsDelegate(of delegate: ChargeBillTableCellDelegate) {
        self.delegate = delegate
    }

    private func updateLabels() {
        orderedLabel.setTextWithFadeAnimation(billRow.orderedQuantity.description)
        orderedPriceLabel.setTextWithFadeAnimation("\(billRow.orderedPrice.description) €")
        pendingLabel.setTextWithFadeAnimation(billRow.pendingQuantity.description)
        pendingPriceLabel.setTextWithFadeAnimation("\(self.billRow.pendingPrice.description) €")
        totalLabel.setTextWithFadeAnimation("\(self.billRow.chargedPaidPrice.description) €")
    }

    // MARK: - Setup

    func setupView() {
        selectionStyle = .none
        setupInfoStackView()
        setupNameLabel()
        setupOrderedStackView()
        setupOrderedLabel()
        setupOrderedPriceLabel()
        setupOrderedQuantitySeparatorView()
        setupQuantitySelector()
        setupQuantityPendingSeparatorView()
        setupPendingStackView()
        setupPendingLabel()
        setupPendingPriceLabel()
        setupPendingTotalSeparatorView()
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
        quantitySelector.show(billRow.chargedPaidQuantity, maxQuantity: billRow.pendingQuantity)
        setupQuantitySelectorConstraints()
    }

    func setupOrderedQuantitySeparatorView() {
        orderedQuantitySeparatorView = UIView()
        addSubview(orderedQuantitySeparatorView)
        orderedQuantitySeparatorView.translatesAutoresizingMaskIntoConstraints = false
        orderedQuantitySeparatorView.backgroundColor = .systemGray4
        setupOrderedQuantitySeparatorViewConstraints()
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
        orderedPriceLabel.text = "\(billRow.orderedPrice.description) €"
        orderedPriceLabel.textAlignment = .center
        orderedPriceLabel.textColor = .lightGray
        orderedPriceLabel.font = UIFont.systemFont(ofSize: 14)
        orderedPriceLabel.adjustsFontSizeToFitWidth = true
    }

    func setupQuantityPendingSeparatorView() {
        quantityPendingSeparatorView = UIView()
        addSubview(quantityPendingSeparatorView)
        quantityPendingSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        quantityPendingSeparatorView.backgroundColor = .systemGray4
        setupQuantityPendingSeparatorViewConstraints()
    }

    func setupPendingStackView() {
        pendingStackView = UIStackView()
        addSubview(pendingStackView)
        pendingStackView.translatesAutoresizingMaskIntoConstraints = false
        pendingStackView.axis = .vertical
        pendingStackView.distribution = .fillProportionally
        setupPendingStackViewConstraints()
    }

    func setupPendingLabel() {
        pendingLabel = UILabel()
        pendingStackView.addArrangedSubview(pendingLabel)
        pendingLabel.translatesAutoresizingMaskIntoConstraints = false
        pendingLabel.text = billRow.pendingQuantity.description
        pendingLabel.textAlignment = .center
        pendingLabel.textColor = .darkGray
        pendingLabel.font = UIFont.systemFont(ofSize: 24)
        pendingLabel.adjustsFontSizeToFitWidth = true
    }

    func setupPendingPriceLabel() {
        pendingPriceLabel = UILabel()
        pendingStackView.addArrangedSubview(pendingPriceLabel)
        pendingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        pendingPriceLabel.text = "\(billRow.pendingPrice.description) €"
        pendingPriceLabel.textAlignment = .center
        pendingPriceLabel.textColor = .lightGray
        pendingPriceLabel.font = UIFont.systemFont(ofSize: 14)
        pendingPriceLabel.adjustsFontSizeToFitWidth = true
    }

    func setupPendingTotalSeparatorView() {
        pendingTotalSeparatorView = UIView()
        addSubview(pendingTotalSeparatorView)
        pendingTotalSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        pendingTotalSeparatorView.backgroundColor = .systemGray4
        setupPendingTotalSeparatorViewConstraints()
    }

    func setupTotalLabel() {
        totalLabel = UILabel()
        addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.text = "\(billRow.paidPrice.description) €"
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
            quantitySelector.leadingAnchor.constraint(equalTo: orderedQuantitySeparatorView.trailingAnchor, constant: 5),
            quantitySelector.widthAnchor.constraint(equalTo: widthAnchor,
                                                    multiplier: 1 / 4)
        ])
    }

    func setupOrderedQuantitySeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            orderedQuantitySeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderedQuantitySeparatorView.leadingAnchor.constraint(equalTo: orderedStackView.trailingAnchor,
                                                               constant: 5),
            orderedQuantitySeparatorView.widthAnchor.constraint(equalToConstant: 1),
            orderedQuantitySeparatorView.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
        ])
    }

    func setupOrderedStackViewConstraints() {
        NSLayoutConstraint.activate([
            orderedStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderedStackView.leadingAnchor.constraint(equalTo: infoStackView.trailingAnchor,
                                               constant: 40),
            orderedStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                    multiplier: 1 / 10)
        ])
    }

    func setupQuantityPendingSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            quantityPendingSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityPendingSeparatorView.leadingAnchor.constraint(equalTo: quantitySelector.trailingAnchor,
                                                               constant: 5),
            quantityPendingSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            quantityPendingSeparatorView.heightAnchor.constraint(equalTo: heightAnchor,
                                                             constant: -20),
        ])
    }

    func setupPendingStackViewConstraints() {
        NSLayoutConstraint.activate([
            pendingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pendingStackView.leadingAnchor.constraint(equalTo: quantityPendingSeparatorView.trailingAnchor,
                                                  constant: 5),
            pendingStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: 1 / 10)
        ])
    }

    func setupPendingTotalSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            pendingTotalSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pendingTotalSeparatorView.leadingAnchor.constraint(equalTo: pendingStackView.trailingAnchor,
                                                               constant: 5),
            pendingTotalSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            pendingTotalSeparatorView.heightAnchor.constraint(equalTo: heightAnchor,
                                                              constant: -20),
        ])
    }

    func setupTotalLabelConstraints() {
        NSLayoutConstraint.activate([
            totalLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: pendingTotalSeparatorView.trailingAnchor,
                                                constant: 5),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -5)
        ])
    }
}


extension ChargeBillTableCell: QuantitySelectorDelegate {
    func quantityDidChange(_ quantitySelector: QuantitySelectorView, to quantity: Int) {
        billRow.chargedPaidQuantity = self.quantitySelector.id == quantitySelector.id ? quantity : billRow.paidQuantity
        updateLabels()
        delegate?.billRowDidChange(billRow)
    }
}
