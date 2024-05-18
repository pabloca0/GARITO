//
//  ChargeBillViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 17/5/24.
//

import UIKit

class ChargeBillViewController: UIViewController {

    // Properties

    var billRows: [BillRow] = []

    // Views
    private var titleLabel: UILabel!
    private var tableView: UITableView!

    // Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // Setup

    func setupView() {
        view.backgroundColor = .systemGray6
        setupTitleLabel()
        setupTableView()
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Cobrar de la cuenta"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .semibold)
        setupTitleLabelConstraints()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds,
                                style: .insetGrouped)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ChargeBillTableCell.self,
                           forCellReuseIdentifier: ChargeBillTableCell.description())

        setupTableViewConstraints()
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: 20)
        ])
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ChargeBillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChargeBillTableCell.description(), for: indexPath) as! ChargeBillTableCell
        let billRow = billRows[indexPath.row]
        cell.show(for: billRow)
        cell.setAsDelegate(of: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !billRows.isEmpty {
            let view = ChargeBillTableHeaderView()
            view.setupViews()
            return view
        }
        return nil
    }
}

extension ChargeBillViewController: ChargeBillTableCellDelegate {
    func billRowDidChange(_ billRow: BillRow) {}
}
