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
    private var paidPendingSeparatorView: UIView!
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
        
        paidStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        pendingStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })

        infoStackView.removeFromSuperview()
        nameLabel.removeFromSuperview()
        quantitySelector.removeFromSuperview()
        quantityPaidSeparatorView.removeFromSuperview()
        paidStackView.removeFromSuperview()
        paidLabel.removeFromSuperview()
        paidPendingSeparatorView.removeFromSuperview()
        pendingStackView.removeFromSuperview()
        pendingLabel.removeFromSuperview()
        pendingPriceLabel.removeFromSuperview()
        pendingTotalSeparatorView.removeFromSuperview()
        totalLabel.removeFromSuperview()

        billRow = nil
        infoStackView = nil
        nameLabel = nil
        quantitySelector = nil
        quantityPaidSeparatorView = nil
        paidStackView = nil
        paidLabel = nil
        paidPriceLabel = nil
        paidPendingSeparatorView = nil
        pendingStackView = nil
        pendingLabel = nil
        pendingPriceLabel = nil
        pendingTotalSeparatorView = nil
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
        paidPriceLabel.setTextWithFadeAnimation("\(billRow.paidPrice.description) €")
        pendingLabel.setTextWithFadeAnimation(billRow.pendingQuantity.description)
        pendingPriceLabel.setTextWithFadeAnimation("\(self.billRow.pendingPrice.description) €")
        totalLabel.setTextWithFadeAnimation("\(self.billRow.orderedPrice.description) €")
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
        setupPaidPendingSeparatorView()
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
        quantitySelector.show(billRow.orderedQuantity, minQuantity: billRow.paidQuantity)
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
        paidPriceLabel.text = "\(billRow.paidPrice.description) €"
        paidPriceLabel.textAlignment = .center
        paidPriceLabel.textColor = .lightGray
        paidPriceLabel.font = UIFont.systemFont(ofSize: 14)
        paidPriceLabel.adjustsFontSizeToFitWidth = true
    }

    func setupPaidPendingSeparatorView() {
        paidPendingSeparatorView = UIView()
        addSubview(paidPendingSeparatorView)
        paidPendingSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        paidPendingSeparatorView.backgroundColor = .systemGray4
        setupPaidPendingSeparatorViewConstraints()
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
        totalLabel.text = "\(billRow.orderedPrice.description) €"
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

    func setupPaidPendingSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            paidPendingSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            paidPendingSeparatorView.leadingAnchor.constraint(equalTo: paidLabel.trailingAnchor,
                                                               constant: 5),
            paidPendingSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            paidPendingSeparatorView.heightAnchor.constraint(equalTo: heightAnchor, 
                                                             constant: -20),
        ])
    }

    func setupPendingStackViewConstraints() {
        NSLayoutConstraint.activate([
            pendingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pendingStackView.leadingAnchor.constraint(equalTo: paidPendingSeparatorView.trailingAnchor,
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


extension SideBarContentTableCell: QuantitySelectorDelegate {
    func quantityDidChange(_ quantitySelector: QuantitySelectorView, to quantity: Int) {
        billRow.orderedQuantity = self.quantitySelector.id == quantitySelector.id ? quantity : billRow.orderedQuantity
        updateLabels()
        delegate?.billRowDidChange(billRow)
    }
}
