//
//  SideBarViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 9/5/24.
//

import UIKit

class SideBarViewController: UISplitViewController {

    // Properties

    var bills: [Bill] = []
    var menuViewController: SideBarMenuViewController!
    var contentViewController: SideBarContentViewController!

    // Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // Setup

    func setupViews() {
        view.backgroundColor = UIColor(red: 179 / 255,
                                       green: 200 / 255,
                                       blue: 172 / 255,
                                       alpha: 1)

        menuViewController = SideBarMenuViewController()
        menuViewController.setAsDelegate(of: self)
        menuViewController.show(bills)
        let navController = UINavigationController(rootViewController: menuViewController)

        contentViewController = SideBarContentViewController()
        contentViewController.setAsDelegate(of: self)
        contentViewController.show(bills.first)

        self.viewControllers = [navController, contentViewController]
    }
}

// SideBarMenuViewControllerDelegate

extension SideBarViewController: SideBarMenuViewControllerDelegate {
    func didSelect(_ bill: Bill) {
        contentViewController.show(bill)
        showDetailViewController(contentViewController, sender: nil)
    }

    func didAdd(_ bill: Bill) {
        bills.append(bill)

        let billIndex = bills.firstIndex(where: { $0.id == bill.id })
        menuViewController.selectBill(at: billIndex)

        contentViewController.show(bill)
    }

    func closeButtonTapped() {
        bills = []
        contentViewController.resetViews()
    }
}

// SideBarMenuViewControllerDelegate

extension SideBarViewController: SideBarContentViewControllerDelegate {
    func billDidChange(_ bill: Bill) {
        if let billIndex = bills.firstIndex(where: { $0.id == bill.id }) {
            bills[billIndex] = bill
            menuViewController.setBills(bills)

            let billIndex = bills.firstIndex(where: { $0.id == bill.id })
            menuViewController.selectBill(at: billIndex)
        }
    }
}
