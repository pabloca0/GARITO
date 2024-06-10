//
//  AddColorViewController.swift
//  TPV
//
//  Created by Pablo Ceacero on 9/5/24.
//

import UIKit

protocol AddBillViewControllerDelegate: AnyObject {
    func didAdd(_ bill: Bill)
}

class AddBillViewController: UIViewController {

    // Properties

    weak var delegate: AddBillViewControllerDelegate?

    // Views
    private var nameLabel = UILabel()
    private var nameTextField = UITextField()
    private var checkMarkButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                  style: .done,
                                                  target: nil,
                                                  action: #selector(checkMarkButtonTapped))

    // Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // Functions

    @objc
    func checkMarkButtonTapped() {
        let billRows = ItemFactory.items.map({ BillRow(item: $0,
                                                       orderedQuantity: 0, 
                                                       paidQuantity: 0,
                                                       chargedPaidQuantity: 0) })
        if let name = nameTextField.text?.uppercased(), !name.isEmpty {
            let bill = Bill(name: name, rows: billRows)
            delegate?.didAdd(bill)
            dismiss(animated: true)
        }
    }

    // Setup

    func setupViews() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupNameLabel()
        setupNameTextField()
    }

    func setupNavigationBar() {
        navigationItem.title = "Crear nueva cuenta"
        navigationItem.rightBarButtonItem = checkMarkButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 18 / 255,
                                                               green: 44 / 255,
                                                               blue: 9 / 255,
                                                               alpha: 1)
    }

    func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = "Nombre de la cuenta:"
        nameLabel.textColor = .systemGray2
        setupNameLabelConstraints()
    }

    func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.delegate = self
        nameTextField.backgroundColor = .systemGray6
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        nameTextField.leftView = paddingView
        nameTextField.rightView = paddingView
        nameTextField.leftViewMode = .always
        nameTextField.rightViewMode = .always
        nameTextField.font = UIFont.systemFont(ofSize: 20)
        nameTextField.layer.cornerRadius = 10
        nameTextField.becomeFirstResponder()
        setupNameTextFieldConstraints()
    }

    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 40)
        ])
    }

    func setupNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension AddBillViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkMarkButtonTapped()
        return true
    }
}
