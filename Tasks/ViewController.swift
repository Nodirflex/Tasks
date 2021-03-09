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
    
    var tasks: [Task] = []
    private let reuseId = "Cell"
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitle(" Новая Задача", for: .normal)
        button.tintColor = UIColor(named: "color")
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.barTintColor = UIColor(named: "color")
        navigationController?.isToolbarHidden = false
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        
        toolbarItems = [UIBarButtonItem(customView: button)]
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
    }
    
    //Добавить новую задачу по кнопке
    @objc func addNewItem(_ sender: UIBarButtonItem){
        let indexPath = IndexPath(row: tasks.count, section: 0)
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        let task = Task(entity: entity, insertInto: context)
        task.item = ""
        tasks.insert(task, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .fade)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.taskCircle.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.taskTitle.textColor = .black
            cell.taskTitle.becomeFirstResponder()
        }
    }
    
    // MARK: - Core data
    func getContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? TaskCell else {return UITableViewCell()}
        cell.updateTVDelegate = self
        cell.deleteCellDelegate = self
        cell.taskTitle.text = tasks[indexPath.row].item
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
            let context = getContext()
            context.delete(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //dimiss keyboard
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
         dismissKeyboard()
    }
    @objc func dismissKeyboard(){
         self.view.endEditing(true)
    }
}

extension ViewController: UserInputCellDelegate {
    //сохранить текст, если есть значение или удалить если его нет
    func didUpdate(cell: TaskCell, string: String?) {
        let context = getContext()
        if let indexPath = tableView.indexPath(for: cell), let text = string, string != ""{
            tasks[indexPath.row].item = text
        }else if let indexPath = tableView.indexPath(for: cell){
            context.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: DeleteCellDelegate{
    //удалить ячейку при нажатии на круглую кнопку через 3 секунды
    func didTappedAt(_ cell: TaskCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            cell.taskCircle.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.taskTitle.textColor = .lightGray
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let context = self.getContext()
                context.delete(self.tasks[indexPath.row])
                self.tasks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
