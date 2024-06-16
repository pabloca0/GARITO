//
//  ChargeBillViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 17/5/24.
//

import UIKit

protocol ChargeBillViewControllerDelegate: AnyObject {
    func billRowsDidChange(_ billRows: [BillRow])
}

class ChargeBillViewController: UIViewController {

    // Properties

    var billRows: [BillRow] = []
    weak var delegate: ChargeBillViewControllerDelegate?

    // Views

    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var chargeButton: UIButton!
    private var selectAllButton: UIButton!

    // Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // Functions

    func updateChargeButton() {
        let billIsEmpty = billRows.filter({ $0.chargedPaidQuantity > 0 }).isEmpty
        chargeButton.setBackgroundColorWithFadeAnimation(billIsEmpty ? .lightGray : UIColor(red: 187 / 255,
                                                                                            green: 72 / 255,
                                                                                            blue: 36 / 255, alpha: 1))
        let quantity = billRows.reduce(0) { $0 + $1.chargedPaidPrice }
        chargeButton.setTitle("COBRAR · \(quantity.toCurrency())", for: .normal)
        chargeButton.isEnabled = !billIsEmpty
    }

    @objc
    func chargeButtonTapped() {
        billRows.enumerated().forEach({
            billRows[$0].paidQuantity += $1.chargedPaidQuantity
            billRows[$0].chargedPaidQuantity = 0
        })
        delegate?.billRowsDidChange(billRows)
        dismiss(animated: true)
    }

    @objc
    func selectAllButtonTapped() {
            billRows.enumerated().forEach({
                billRows[$0].chargedPaidQuantity = $1.orderedQuantity - $1.paidQuantity
            })
            tableView.reloadData()
        updateChargeButton()
    }

    // Setup

    func setupView() {
        view.backgroundColor = .systemGray6
        setupTitleLabel()
        setupChargeButton()
        setupTableView()
        setupSelectAllButton()
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

    func setupChargeButton() {
        chargeButton = UIButton()
        view.addSubview(chargeButton)
        chargeButton.translatesAutoresizingMaskIntoConstraints = false
        chargeButton.setTitle("COBRAR · \(0.toCurrency())", for: .normal)
        chargeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                          weight: .semibold)
        chargeButton.layer.cornerRadius = 60 / 2
        let billIsEmpty = billRows.filter({ $0.chargedPaidQuantity > 0 }).isEmpty
        chargeButton.backgroundColor = billIsEmpty ? .lightGray : UIColor(red: 187 / 255,
                                                                          green: 72 / 255,
                                                                          blue: 36 / 255, alpha: 1)
        chargeButton.isEnabled = !billIsEmpty
        chargeButton.addTarget(self,
                               action: #selector(chargeButtonTapped),
                               for: .touchUpInside)

        setupChargeButtonConstraints()
    }

    func setupSelectAllButton() {
        selectAllButton = UIButton()
        view.addSubview(selectAllButton)
        selectAllButton.translatesAutoresizingMaskIntoConstraints = false
        selectAllButton.setTitle("Cobrar todo", for: .normal)
        selectAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                             weight: .semibold)
        selectAllButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 10 ,bottom: 0,right: 10)
        selectAllButton.titleLabel?.adjustsFontSizeToFitWidth = true
        selectAllButton.layer.cornerRadius = 30 / 2
        selectAllButton.backgroundColor = UIColor(red: 18 / 255,
                                               green: 44 / 255,
                                               blue: 9 / 255,
                                               alpha: 1)
        selectAllButton.addTarget(self,
                               action: #selector(selectAllButtonTapped),
                               for: .touchUpInside)

        setupSelectAllButtonConstraints()
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: 20)
        ])
    }

    func setupChargeButtonConstraints() {
        NSLayoutConstraint.activate([
            chargeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: -20),
            chargeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                              constant: 20),
            chargeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                              constant: -20),
            chargeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setupSelectAllButtonConstraints() {
        NSLayoutConstraint.activate([
            selectAllButton.bottomAnchor.constraint(equalTo: tableView.topAnchor,
                                              constant: -10),
            selectAllButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,
                                              constant: -20),
            selectAllButton.heightAnchor.constraint(equalToConstant: 30),
            selectAllButton.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: 10),
            tableView.bottomAnchor.constraint(equalTo: chargeButton.topAnchor,
                                              constant: -20),
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
    func billRowDidChange(_ billRow: BillRow) {
        if let rowIndex = billRows.firstIndex(where: { $0.id == billRow.id }) {
            billRows[rowIndex] = billRow
            updateChargeButton()
        }
    }
}
