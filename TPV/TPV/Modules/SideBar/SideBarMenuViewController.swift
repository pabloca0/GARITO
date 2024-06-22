//
//  SideBarMenuViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 9/5/24.
//

import UIKit

protocol SideBarMenuViewControllerDelegate: AnyObject {
    func didSelect(_ bill: Bill)
    func didAdd(_ bill: Bill)
    func closeButtonTapped()
}

class SideBarMenuViewController: UIViewController {

    // Properties
    private weak var delegate: SideBarMenuViewControllerDelegate?
    private var bills: [Bill] = []

    // Views
    private var tableView = UITableView()
    private var closeButton = UIButton()
    private lazy var selectedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 183 / 255,
                                       green: 199 / 255,
                                       blue: 174 / 255,
                                       alpha: 1)
        return view
    }()

    // Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // Setup

    func setupViews() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupCloseButton()
        setupTableView()
    }

    func setupNavigationBar() {
        navigationItem.title = "Cuentas"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addBillTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 18 / 255,
                                                               green: 44 / 255,
                                                               blue: 9 / 255,
                                                               alpha: 1)
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds,
                                style: .insetGrouped)
        view.addSubview(tableView)
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SideBarMenuTableCell.self,
                           forCellReuseIdentifier: SideBarMenuTableCell.description())

        setupTableViewConstraints()
    }

    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Cerrar turno", for: .normal)
        closeButton.backgroundColor = UIColor(red: 187 / 255,
                                              green: 72 / 255,
                                              blue: 36 / 255, alpha: 1)
        closeButton.layer.cornerRadius = 40 / 2
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.isHidden = bills.isEmpty
        setupCloseButtonConstraints()
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupCloseButtonConstraints() {
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }

    // Functions

    func show(_ bills: [Bill]) {
        self.bills = bills
        self.tableView.reloadData()
    }

    func setAsDelegate(of delegate: SideBarMenuViewControllerDelegate) {
        self.delegate = delegate
    }

    func setBills(_ bills: [Bill]) {
        self.bills = bills
        tableView.reloadData()
    }

    func selectBill(at index: Int?) {
        Task {
            if let index {
                tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
            }
        }
    }

    @objc
    func addBillTapped() {
        let addColorVC = AddBillViewController()
        let nav = UINavigationController(rootViewController: addColorVC)
        addColorVC.delegate = self
        present(nav, animated: true)
    }

    @objc
    func closeButtonTapped() {
        let summaryVC =  CloseShiftViewController()
        present(summaryVC, animated: true)

//        bills = []
//        closeButton.hideIf(bills.isEmpty)
//        tableView.reloadData()
//        delegate?.closeButtonTapped()
    }
}

// TableView

extension SideBarMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideBarMenuTableCell.description(),
                                                 for: indexPath) as! SideBarMenuTableCell
        cell.setup(title: bills[indexPath.row].name,
                   orderedPrice: bills[indexPath.row].orderedPrice.toCurrency(),
                   pendingPrice: bills[indexPath.row].pendingPrice.toCurrency(),
                   paidPrice: bills[indexPath.row].paidPrice.toCurrency(),
                   statusColor: bills[indexPath.row].status.displayColor)
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(bills[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - AddBillViewControllerDelegate

extension SideBarMenuViewController: AddBillViewControllerDelegate {
    func didAdd(_ bill: Bill) {
        bills.append(bill)
        closeButton.hideIf(bills.isEmpty)
        tableView.reloadData()
        delegate?.didAdd(bill)
    }
}
