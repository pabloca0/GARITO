//
//  HistoricActionsViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 16/6/24.
//

import UIKit

final class HistoricActionsViewController: UIViewController {

    // MARK: - Properties

    private var historicActions: [HistoricAction]

    // MARK: - Views

    private var tableView: UITableView!

    // MARK: - Life cycle

    init(historicActions: [HistoricAction]) {
        self.historicActions = historicActions.reversed()
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup

extension HistoricActionsViewController {

    func setup() {
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        setupTableViewConstraints()
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - TableView

extension HistoricActionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historicActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                 for: indexPath)

        let action = historicActions[indexPath.row]
        let actionEmoji = action.action.emoji
        let dateString = "[\(action.date.toString(withFormat: "MM-dd-yyyy HH:mm:ss"))]:"
        let actionString = action.action.description

        var content = cell.defaultContentConfiguration()
        content.textProperties.font = UIFont.systemFont(ofSize: 14)
        content.text = "\(actionEmoji) \(dateString) \(actionString)"
        content.textProperties.numberOfLines = 0

        cell.contentConfiguration = content
        return cell
    }
}
