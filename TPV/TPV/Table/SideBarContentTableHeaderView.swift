//
//  SideBarContentTableHeader.swift
//  TPV
//
//  Created by Pablo Ceacero on 17/5/24.
//

import UIKit

class SideBarContentTableHeaderView: UIView {

    // Views

    private var nameLabel: UILabel!
    private var orderedLabel: UILabel!
    private var paidLabel: UILabel!
    private var pendingLabel: UILabel!
    private var totalLabel: UILabel!

    // Setup

    func setupViews() {
        setupNameLabel()
        setupOrderedLabel()
        setupPaidLabel()
        setupPendingLabel()
        setupTotalLabel()
    }

    func setupNameLabel() {
        nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .gray
        nameLabel.text = "PRODUCTO"
        setupNameLabelConstraints()
    }

    func setupOrderedLabel() {
        orderedLabel = UILabel()
        addSubview(orderedLabel)
        orderedLabel.translatesAutoresizingMaskIntoConstraints = false
        orderedLabel.textAlignment = .center
        orderedLabel.font = UIFont.systemFont(ofSize: 12)
        orderedLabel.textColor = .gray
        orderedLabel.text = "APUNTADO"
        setupOrderedLabelConstraints()
    }

    func setupPaidLabel() {
        paidLabel = UILabel()
        addSubview(paidLabel)
        paidLabel.translatesAutoresizingMaskIntoConstraints = false
        paidLabel.textAlignment = .center
        paidLabel.font = UIFont.systemFont(ofSize: 12)
        paidLabel.textColor = .gray
        paidLabel.text = "PAGADO"
        setupPaidLabelConstraints()
    }

    func setupPendingLabel() {
        pendingLabel = UILabel()
        addSubview(pendingLabel)
        pendingLabel.translatesAutoresizingMaskIntoConstraints = false
        pendingLabel.textAlignment = .center
        pendingLabel.font = UIFont.systemFont(ofSize: 12)
        pendingLabel.textColor = .gray
        pendingLabel.text = "PENDIENTE"
        setupPendingLabelConstraints()
    }

    func setupTotalLabel() {
        totalLabel = UILabel()
        addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textAlignment = .center
        totalLabel.font = UIFont.systemFont(ofSize: 12)
        totalLabel.textColor = .gray
        totalLabel.text = "TOTAL"
        setupTotalLabelConstraints()
    }

    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 20),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: 1 / 3)
        ])
    }

    func setupOrderedLabelConstraints() {
        NSLayoutConstraint.activate([
            orderedLabel.topAnchor.constraint(equalTo: topAnchor),
            orderedLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -5),
            orderedLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor,
                                                  constant: 40),
            orderedLabel.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: 1 / 4)
        ])
    }

    func setupPaidLabelConstraints() {
        NSLayoutConstraint.activate([
            paidLabel.topAnchor.constraint(equalTo: topAnchor),
            paidLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -5),
            paidLabel.leadingAnchor.constraint(equalTo: orderedLabel.trailingAnchor,
                                               constant: 11),
            paidLabel.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: 1 / 10)

        ])
    }

    func setupPendingLabelConstraints() {
        NSLayoutConstraint.activate([
            pendingLabel.topAnchor.constraint(equalTo: topAnchor),
            pendingLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -5),
            pendingLabel.leadingAnchor.constraint(equalTo: paidLabel.trailingAnchor,
                                                  constant: 11),
            pendingLabel.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: 1 / 10)
        ])
    }

    func setupTotalLabelConstraints() {
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: topAnchor),
            totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -5),
            totalLabel.leadingAnchor.constraint(equalTo: pendingLabel.trailingAnchor,
                                                constant: 11),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -5)
        ])
    }
}
