//
//  ViewController.swift
//  Tasks
//
//  Created by user on 05.03.2021.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var tasks: [String] = ["2", "3", "4"]
    private let reuseId = "Cell"
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Tasks"
        navigationController?.isToolbarHidden = false
        toolbarItems = [UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(addNewItem))]
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc func addNewItem(_ sender: UIBarButtonItem){
        let indexPath = IndexPath(row: tasks.count, section: 0)
        tasks.insert("", at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .fade)
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.taskCircle.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.taskTitle.textColor = .black
            cell.taskTitle.becomeFirstResponder()
        }
    }
    
    // MARK: - Save data
    
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? TaskCell else {return UITableViewCell()}
        cell.updateTFDelegate = self
        cell.deleteCellDelegate = self
        cell.taskTitle.text = tasks[indexPath.row]
        cell.selectionStyle = .none
        
        cell.refreshCell = {
            () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController: UserInputCellDelegate {
    func didUpdate(cell: TaskCell, string: String?) {
        if let indexPath = tableView.indexPath(for: cell) {
            tasks[indexPath.row] = string ?? ""
        }
    }
}

extension ViewController: DeleteCellDelegate{
    func didTappedAt(_ cell: TaskCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            cell.taskCircle.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.taskTitle.textColor = .lightGray
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tasks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
