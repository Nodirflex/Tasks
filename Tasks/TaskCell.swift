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
    
    var refreshCell:(() -> Void)? = nil

    @IBOutlet weak var taskCircle: UIButton!
    @IBOutlet weak var taskTitle: UITextView!
    
    weak var updateTFDelegate: UserInputCellDelegate?
    weak var deleteCellDelegate: DeleteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskTitle.delegate = self
        taskTitle.isScrollEnabled = false
        taskTitle.sizeToFit()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        deleteCellDelegate?.didTappedAt(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateTFDelegate?.didUpdate(cell: self, string: textView.text)
    }
    
    //
    func textViewDidChange(_ textView: UITextView) {
        perform(#selector(queuedTextVewDidChange),
                with: nil,
                afterDelay: 0.1)
    }
    @objc func queuedTextVewDidChange() {
        if let refreshCell = refreshCell {
            refreshCell()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.endEditing(true)
            return false
        }else{
            return true
        }
    }
}

extension TaskCell: UITextViewDelegate{}

extension TaskCell: UITextFieldDelegate{}
