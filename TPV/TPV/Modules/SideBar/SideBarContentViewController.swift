//
//  SideBarContentViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 9/5/24.
//

import UIKit

protocol SideBarContentViewControllerDelegate: AnyObject {
    func billDidChange(_ bill: Bill)
}

class SideBarContentViewController: UIViewController {

    // Properties
    var bill: Bill!
    var segmentedControlTags = [SegmentedControlTag.all, SegmentedControlTag.recorded]
    
    var selectedTag: SegmentedControlTag!
    private weak var delegate: SideBarContentViewControllerDelegate?

    // Views

    private var nameLabel: UILabel!
    private var statusView: StatusView!
    private var totalLabel: UILabel!
    private var segmentedControl: UISegmentedControl!
    private var tableView: UITableView!
    private var chargeButton: UIButton!

    // Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Functions

    func show(_ bill: Bill?) {
        resetViews()
        if let bill {
            self.bill = bill
            setupViews()
        }
    }

    func setAsDelegate(of delegate: SideBarContentViewControllerDelegate) {
        self.delegate = delegate
    }

    func resetViews() {
        view.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        nameLabel = nil
        statusView = nil
        totalLabel = nil
        segmentedControl = nil
        tableView = nil
        chargeButton = nil
    }

    @objc
    private func segmentedControlValueDidChange() {
        selectedTag = segmentedControlTags[segmentedControl.selectedSegmentIndex]
        tableView.reloadSections([0], with: .fade)
    }

    @objc
    private func chargeButtonTapped() {
        let vc = ChargeBillViewController()
        vc.billRows = bill.rows.filter({ $0.pendingQuantity > 0 })
        present(vc, animated: true)
    }

    private func updateBill() {
        totalLabel.setTextWithFadeAnimation("TOTAL: \(bill.totalPrice.description) €")
        statusView.show(bill.status)
    }

    // Setup

    func setupViews() {
        setupNameLabel()
        setupStatusView()
        setupTotalLabel()
        setupSegmentedControl()
        setupTableView()
        setupChargeButton()
    }

    func setupNameLabel() {
        nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.text = bill.name
        setupNameLabelConstraints()
    }

    func setupStatusView() {
        statusView = StatusView()
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.show(bill.status)
        setupStatusViewConstraints()
    }

    func setupTotalLabel() {
        totalLabel = UILabel()
        view.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textColor = .white
        totalLabel.text = "TOTAL: \(bill.totalPrice.description) €"
        totalLabel.font = UIFont.systemFont(ofSize: 16)
        setupTotalLabelConstraints()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds,
                                style: .insetGrouped)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SideBarContentTableCell.self,
                           forCellReuseIdentifier: SideBarContentTableCell.description())

        setupTableViewConstraints()
    }

    func setupSegmentedControl() {
        segmentedControl = UISegmentedControl()
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlValueDidChange),
                                   for: .valueChanged)
        segmentedControlTags.enumerated().forEach({
            segmentedControl.insertSegment(withTitle: $1.title, at: $0, animated: false)
        })
        segmentedControl.selectedSegmentIndex = 0
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        selectedTag = .all
        setupSegmentedControlConstraints()
    }

    func setupChargeButton() {
        chargeButton = UIButton()
        view.addSubview(chargeButton)
        chargeButton.translatesAutoresizingMaskIntoConstraints = false
        chargeButton.setTitle("COBRAR", for: .normal)
        chargeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                          weight: .semibold)
        chargeButton.layer.cornerRadius = 60 / 2
        chargeButton.backgroundColor = UIColor(red: 187 / 255,
                                               green: 72 / 255,
                                               blue: 36 / 255, alpha: 1)
        chargeButton.addTarget(self,
                               action: #selector(chargeButtonTapped),
                               for: .touchUpInside)
        setupChargeButtonConstraints()
    }

    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, 
                                           constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 20)
        ])
    }

    func setupStatusViewConstraints() {
        NSLayoutConstraint.activate([
            statusView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            statusView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, 
                                                constant: 20),
            statusView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setupTotalLabelConstraints() {
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 20)

        ])
    }

    func setupSegmentedControlConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupChargeButtonConstraints() {
        NSLayoutConstraint.activate([
            chargeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                 constant: -20),
            chargeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -20),
            chargeButton.widthAnchor.constraint(equalToConstant: 180),
            chargeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension SideBarContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTag == .all ? bill.rows.count : bill.rows.filter({ $0.orderedQuantity > 0 }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayData = selectedTag == .all ? bill.rows : bill.rows.filter({ $0.orderedQuantity > 0 })
        let cell = tableView.dequeueReusableCell(withIdentifier: SideBarContentTableCell.description(), for: indexPath) as! SideBarContentTableCell
        let billRow = arrayData[indexPath.row]
        cell.show(for: billRow)
        cell.setAsDelegate(of: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SideBarContentTableHeaderView()
        view.setupViews()
        return view
    }
}

extension SideBarContentViewController {
    enum SegmentedControlTag {
        case all
        case recorded

        var title: String {
            switch self {
            case .all: return "TODO"
            case .recorded: return "CUENTA"
            }
        }
    }
}

extension SideBarContentViewController: SideBarContentTableCellDelegate {
    func billRowDidChange(_ billRow: BillRow) {
        if let rowIndex = bill.rows.firstIndex(where: { $0.id == billRow.id }) {
            bill.rows[rowIndex] = billRow
            updateBill()
            delegate?.billDidChange(bill)
        }
    }
}
