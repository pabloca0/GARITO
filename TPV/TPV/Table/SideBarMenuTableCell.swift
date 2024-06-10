//
//  SideBarMenuTableCell.swift
//  TPV
//
//  Created by Pablo Ceacero on 10/6/24.
//

import UIKit

final class SideBarMenuTableCell: UITableViewCell {

    // MARK: - Properties

    private var title: String?
    private var orderedPrice: String?
    private var pendingPrice: String?
    private var paidPrice: String?
    private var statusColor: UIColor?

    // MARK: - Views

    private var mainStackView: UIStackView!
    private var infoStackView: UIStackView!
    private var priceStackView: UIStackView!
    private var titleLabel: UILabel!
    private var orderedPriceLabel: UILabel!
    private var pendingPriceLabel: UILabel!
    private var paidPriceLabel: UILabel!
    private var statusView: UIView!
    private var statusCircle: UIView!

    // MARK: - Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        mainStackView.subviews.forEach({ $0.removeFromSuperview() })
        mainStackView.removeFromSuperview()
        mainStackView = nil

        infoStackView.subviews.forEach({ $0.removeFromSuperview() })
        infoStackView.removeFromSuperview()
        infoStackView = nil

        priceStackView.subviews.forEach({ $0.removeFromSuperview() })
        priceStackView.removeFromSuperview()
        priceStackView = nil

        titleLabel.removeFromSuperview()
        titleLabel = nil

        orderedPriceLabel.removeFromSuperview()
        orderedPriceLabel = nil

        statusView.removeFromSuperview()
        statusView = nil

        statusCircle.removeFromSuperview()
        statusCircle = nil
    }

    // MARK: - Public functions

    func setup(title: String,
               orderedPrice: String?,
               pendingPrice: String?,
               paidPrice: String?,
               statusColor: UIColor?) {
        self.title = title
        self.orderedPrice = orderedPrice
        self.pendingPrice = pendingPrice
        self.paidPrice = paidPrice
        self.statusColor = statusColor
        setupView()
    }
}

// MARK: - Setup

private extension SideBarMenuTableCell {
    func setupView() {
        setupMainStackView()
        setupInfoStackView()
        setupTitleLabel()
        setupPriceStackView()
        setupOrderedPriceLabel()
        setupPendingPriceLabel()
        setupPaidPriceLabel()
        priceStackView.addArrangedSubview(UIView())
        setupStatusView()
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        setupMainStackViewContraints()
    }

    func setupInfoStackView() {
        infoStackView = UIStackView()
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        infoStackView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    func setupPriceStackView() {
        priceStackView = UIStackView()
        infoStackView.addArrangedSubview(priceStackView)
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.spacing = 15
    }

    func setupOrderedPriceLabel() {
        orderedPriceLabel = UILabel()
        priceStackView.addArrangedSubview(orderedPriceLabel)
        orderedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        if let orderedPrice {
            orderedPriceLabel.text = "🗒️ \(orderedPrice)"
        }
        orderedPriceLabel.textColor = .darkGray
        orderedPriceLabel.font = UIFont.systemFont(ofSize: 14)
    }

    func setupPendingPriceLabel() {
        pendingPriceLabel = UILabel()
        priceStackView.addArrangedSubview(pendingPriceLabel)
        pendingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        if let pendingPrice {
            pendingPriceLabel.text = "⚠️ \(pendingPrice)"
        }
        pendingPriceLabel.textColor = .darkGray
        pendingPriceLabel.font = UIFont.systemFont(ofSize: 14)
    }

    func setupPaidPriceLabel() {
        paidPriceLabel = UILabel()
        priceStackView.addArrangedSubview(paidPriceLabel)
        paidPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        if let paidPrice {
            paidPriceLabel.text = "💰 \(paidPrice)"
        }
        paidPriceLabel.textColor = .darkGray
        paidPriceLabel.font = UIFont.systemFont(ofSize: 14)
    }

    func setupStatusView() {
        statusView = UIView()
        mainStackView.addArrangedSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        setupStatusCircle()
        setupStatusViewConstraints()
    }

    func setupStatusCircle() {
        statusCircle = UIView()
        statusView.addSubview(statusCircle)
        statusCircle.translatesAutoresizingMaskIntoConstraints = false
        statusCircle.backgroundColor = statusColor
        statusCircle.layer.cornerRadius = 5
        setupStatusCircleViewContraints()
    }

    func setupMainStackViewContraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    func setupStatusViewConstraints() {
        NSLayoutConstraint.activate([
            statusView.widthAnchor.constraint(equalToConstant: 10)
        ])
    }

    func setupStatusCircleViewContraints() {
        NSLayoutConstraint.activate([
            statusCircle.heightAnchor.constraint(equalToConstant: 10),
            statusCircle.widthAnchor.constraint(equalToConstant: 10),
            statusCircle.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusCircle.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
        ])
    }
}
