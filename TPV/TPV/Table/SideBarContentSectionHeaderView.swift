//
//  SideBarContentTableCellSectionHeaderView.swift
//  TPV
//
//  Created by Pablo Ceacero on 19/5/24.
//

import UIKit

protocol SideBarContentSectionHeaderViewDelegate: AnyObject {
    func sectionStatusDidChange(_ status: SideBarContentSectionHeaderView.Status, for category: ItemFactory.Category)
}

class SideBarContentSectionHeaderView: UIView {

    // MARK: - Properties
    private var category: ItemFactory.Category!
    private var status: SideBarContentSectionHeaderView.Status!
    weak var delegate: SideBarContentSectionHeaderViewDelegate?

    // MARK: - Views

    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var button: UIButton!

    // MARK: - Functions

    @objc
    func buttonDidTapped() {
        let newStatus = status == .open ? SideBarContentSectionHeaderView.Status.collapsed : .open
        status = newStatus
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let self else { return }
            self.iconImageView.transform = self.iconImageView.transform.rotated(by: self.status == .open ?
                                                                                CGFloat(Double.pi/2) : CGFloat(-(Double.pi/2)))
        }) { [weak self] _ in
            guard let self else { return }
            self.delegate?.sectionStatusDidChange(self.status, for: self.category)
        }
    }

    // MARK: - Setup

    func setupViews(with category: ItemFactory.Category, status: SideBarContentSectionHeaderView.Status) {
        self.category = category
        self.status = status
        setupIconImageView()
        setupTitleLabel()
        setupButton()
    }

    func setupIconImageView() {
        iconImageView = UIImageView()
        addSubview(iconImageView)
        iconImageView.tintColor = .black
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: "arrowtriangle.right.square.fill")
        if self.status == .open {
            self.iconImageView.transform = self.iconImageView.transform.rotated(by: CGFloat(Double.pi/2))
        }

        setupIconImageViewConstraints()
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = category.rawValue
        titleLabel.font = UIFont.systemFont(ofSize: 24,
                                            weight: .semibold)
        setupTitleLabelConstraints()
    }

    func setupButton() {
        button = UIButton()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(buttonDidTapped),
                         for: .touchUpInside)
        setupButtonConstraints()
    }

    func setupIconImageViewConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: -10)
        ])
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,
                                                constant: 8)
        ])
    }

    func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension SideBarContentSectionHeaderView {

    enum Status {
        case open
        case collapsed
    }
}
