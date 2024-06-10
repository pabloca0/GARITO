//
//  SideBarContentViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 9/5/24.
//

import UIKit

protocol SideBarContentViewControllerDelegate: AnyObject {
    func billDidChange(_ bill: Bill)
    func selectedTagDidChange(selectedTag: SideBarContentViewController.SideBarContentTag, for billId: Bill.ID)
}

final class SideBarContentViewController: UIViewController {

    // MARK: - Properties

    var bill: Bill!
    var selectedTag: SideBarContentTag = .all
    private weak var delegate: SideBarContentViewControllerDelegate?

    private var categories: [ItemFactory.Category] {
        return ItemFactory.getCategories(from: items)
    }

    private var items: [Item] {
        selectedTag == .all ? bill.rows.map({ $0.item }) : bill.rows.compactMap({ $0.orderedQuantity > 0 ?  $0.item : nil})
    }

    private var categoriesStatus: [ItemFactory.Category: SideBarContentSectionHeaderView.Status] = [:]

    // MARK: - Views

    private var nameLabel: UILabel!
    private var statusView: StatusView!
    private var totalLabel: UILabel!
    private var segmentedControl: UISegmentedControl!
    private var tableHeaderView: SideBarContentTableHeaderView!
    private var tableView: UITableView!
    private var chargeButton: UIButton!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Functions

    func show(_ bill: Bill?, selectedTag: SideBarContentTag) {
        resetViews()
        if let bill {
            self.bill = bill
            self.selectedTag = selectedTag
            categories.forEach({ category in
                categoriesStatus[category] = .open
            })
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
        selectedTag = SideBarContentTag.allCases[segmentedControl.selectedSegmentIndex]
        delegate?.selectedTagDidChange(selectedTag: selectedTag, for: bill.id)
        UIView.transition(with: tableView,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        })
    }

    @objc
    private func chargeButtonTapped() {
        let chargeBillVC = ChargeBillViewController()
        chargeBillVC.delegate = self
        let billRowsWithPending = bill.rows.filter({ $0.pendingQuantity > 0 })
        chargeBillVC.billRows = billRowsWithPending
        present(chargeBillVC, animated: true)
    }

    private func updateBill() {
        totalLabel.setTextWithFadeAnimation("TOTAL: \(bill.orderedPrice.toCurrency())")
        statusView.showWithFade(bill.status)
        let billIsEmpty = bill.rows.filter({ $0.pendingQuantity > 0 }).isEmpty
        chargeButton.setBackgroundColorWithFadeAnimation(billIsEmpty ? .lightGray : UIColor(red: 187 / 255,
                                                                                            green: 72 / 255,
                                                                                            blue: 36 / 255, alpha: 1))
        chargeButton.isEnabled = !billIsEmpty
    }

    // MARK: - Setup

    func setupViews() {
        setupNameLabel()
        setupStatusView()
        setupTotalLabel()
        setupSegmentedControl()
        setupTableHeaderView()
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
        statusView.showWithFade(bill.status)
        setupStatusViewConstraints()
    }

    func setupTotalLabel() {
        totalLabel = UILabel()
        view.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textColor = .white
        totalLabel.text = "TOTAL: \(bill.orderedPrice.toCurrency())"
        totalLabel.font = UIFont.systemFont(ofSize: 16)
        setupTotalLabelConstraints()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds,
                                style: .insetGrouped)
        view.addSubview(tableView)
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 40
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SideBarContentTableCell.self,
                           forCellReuseIdentifier: SideBarContentTableCell.description())

        setupTableViewConstraints()
    }

    func setupTableHeaderView() {
        tableHeaderView = SideBarContentTableHeaderView()
        view.addSubview(tableHeaderView)
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.setupViews()
        setupTableHeaderViewConstraints()
    }

    func setupSegmentedControl() {
        segmentedControl = UISegmentedControl()
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlValueDidChange),
                                   for: .valueChanged)
        SideBarContentTag.allCases.enumerated().forEach({
            segmentedControl.insertSegment(withTitle: $1.title, at: $0, animated: false)
        })
        segmentedControl.selectedSegmentIndex = SideBarContentTag.allCases.firstIndex(of: selectedTag) ?? 0
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
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
        let billIsEmpty = bill.rows.filter({ $0.pendingQuantity > 0 }).isEmpty
        chargeButton.backgroundColor = billIsEmpty ? .lightGray : UIColor(red: 187 / 255,
                                                                          green: 72 / 255,
                                                                          blue: 36 / 255, alpha: 1)
        chargeButton.isEnabled = !billIsEmpty
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

    func setupTableHeaderViewConstraints() {
        NSLayoutConstraint.activate([
            tableHeaderView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                                    constant: 10),
            tableHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 16),
            tableHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -16),
            tableHeaderView.heightAnchor.constraint(equalToConstant: 20)
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
            tableView.topAnchor.constraint(equalTo: tableHeaderView.bottomAnchor),
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
    func numberOfSections(in tableView: UITableView) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCategory = categories[section]
        if categoriesStatus[sectionCategory] == .collapsed { return 0 }
        return items.filter({ sectionCategory == $0.category }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideBarContentTableCell.description(), for: indexPath) as! SideBarContentTableCell


        let items = items.filter({ categories[indexPath.section] == $0.category })
        let showingItem = items[indexPath.row]

        guard let billRow = bill.rows.first(where: { $0.item.id == showingItem.id }) else { fatalError() }
        cell.show(for: billRow)
        cell.setAsDelegate(of: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SideBarContentSectionHeaderView()
        
        let category = categories[section]

        header.setupViews(with: category, status: categoriesStatus[category] ?? .open)
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
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

extension SideBarContentViewController: ChargeBillViewControllerDelegate {
    func billRowsDidChange(_ billRows: [BillRow]) {
        billRows.forEach { billRow in
            if let rowIndex = bill.rows.firstIndex(where: { $0.id == billRow.id }) {
                bill.rows[rowIndex] = billRow
            }
        }
        tableView.reloadData()
        updateBill()
        delegate?.billDidChange(bill)
    }
}

extension SideBarContentViewController: SideBarContentSectionHeaderViewDelegate {
    func sectionStatusDidChange(_ status: SideBarContentSectionHeaderView.Status, for category: ItemFactory.Category) {
        categoriesStatus[category] = status

        UIView.transition(with: tableView,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        })
    }
}

extension SideBarContentViewController {

    enum SideBarContentTag: CaseIterable {
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
