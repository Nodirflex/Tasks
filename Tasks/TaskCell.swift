//
//  TableViewCell.swift
//  Tasks
//
//  Created by user on 05.03.2021.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

protocol UserInputCellDelegate: class {
    func didUpdate(cell: TaskCell, string: String?)
}

protocol DeleteCellDelegate: class {
    func didTappedAt(_ cell: TaskCell)
}

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskCircle: UIButton!
    
    weak var updateTFDelegate: UserInputCellDelegate?
    weak var deleteCellDelegate: DeleteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskName.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        deleteCellDelegate?.didTappedAt(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTFDelegate?.didUpdate(cell: self, string: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.endEditing(true)
        return false
    }
}

extension TaskCell: UITextFieldDelegate{}
