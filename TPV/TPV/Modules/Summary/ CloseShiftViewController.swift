//
//  CloseShiftViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 16/6/24.
//

import UIKit

final class  CloseShiftViewController: UIViewController {

    // MARK: - Views

    private var titleLabel: UILabel!
    private var summaryView: UIView!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup

private extension  CloseShiftViewController {
    func setup() {
        view.backgroundColor = .systemGray6
        setupTitleLabel()
        setupSummaryView()
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Cerrar turno"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .semibold)
        setupTitleLabelConstraints()
    }

    func setupSummaryView() {
        summaryView = UIView()
        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}
