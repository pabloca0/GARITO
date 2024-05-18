//
//  StatusView.swift
//  TPV
//
//  Created by Pablo Ceacero on 13/5/24.
//

import UIKit

class StatusView: UIView {

    // Properties
    var status: Bill.Status!

    // Views
    private var nameLabel = UILabel()
    private var contentView = UIView()

    // Functions
    func show(_ status: Bill.Status) {
        self.status = status
        setupViews()
    }

    // Setup

    func setupViews() {
        setupContentView()
        setupNameLabel()
    }

    func setupContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.borderColor = status.displayColor.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = status.displayColor
        setupContentViewConstraints()
    }

    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16,
                                           weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.text = status.displayName
        nameLabel.textColor = .white
        setupNameLabelConstraints()
    }

    func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
}
