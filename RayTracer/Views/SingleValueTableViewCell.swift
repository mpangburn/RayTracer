//
//  SingleValueTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol SingleValueTableViewCellDelegate: class {
    func singleValueTableViewCellDidBeginEditing(_ cell: SingleValueTableViewCell)
    func singleValueTableViewCellValueDidChange(_ cell: SingleValueTableViewCell)
}


final class SingleValueTableViewCell: UITableViewCell, UITextFieldDelegate {

    weak var delegate: SingleValueTableViewCellDelegate?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField! {
        didSet {
            valueTextField.delegate = self
        }
    }

    var value: Double {
        get {
            return Double(valueTextField.text!) ?? 0
        }
        set {
            valueTextField.text = newValue.cleanValueString
        }
    }

    private var valueBeforeEditing = 0.0

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        valueBeforeEditing = value
        valueTextField.text = ""
        delegate?.singleValueTableViewCellDidBeginEditing(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if valueTextField.text!.isEmpty {
            value = valueBeforeEditing
        }
        delegate?.singleValueTableViewCellValueDidChange(self)
    }
}
