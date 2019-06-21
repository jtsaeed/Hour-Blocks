//
//  ToDoViewController.swift
//  neon
//
//  Created by James Saeed on 13/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import Intents

class ToDoViewController: UIViewController, Storyboarded {
	
	weak var coordinator: ToDoCoordinator?
	
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var itemsLabel: UILabel!
    
    var items = [ToDoItem]() {
		didSet {
			items = items.sorted().reversed()
            itemsLabel.text = "\(items.count) ITEMS"
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        items = DataGateway.shared.loadToDos()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        INPreferences.requestSiriAuthorization { status in }
    }
	
    @IBAction func addButtonPressed(_ sender: Any) {
        showAddToDoDialog(index: nil)
    }
    
    @IBAction func swipedLeft(_ sender: Any) {
		tabBarController?.selectedIndex = 1
	}
}

// MARK: - Functionality

extension ToDoViewController {
    
    func addToDoItem(title: String, priority: ToDoPriority) {
        let toDoItem = ToDoItem(id: nil, title: title, priority: priority)
        items.append(toDoItem)
        DataGateway.shared.saveToDo(item: toDoItem)
        
        if let index = items.firstIndex(of: toDoItem) {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    func removeToDoItem(at index: Int) {
        DataGateway.shared.deleteToDo(item: items[index])
        items.remove(at: index)
        
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

// MARK: - Collection View

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoBlockCell", for: indexPath) as? ToDoBlockCell else { return UITableViewCell() }
        cell.build(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { self.showToDoOptionsDialog(for: indexPath.row) }
    }
}

// MARK: - Dialogs

extension ToDoViewController: AddToDoDelegate {
    
    func showToDoOptionsDialog(for index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            self.showAddToDoDialog(index: index)
        }))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            self.removeToDoItem(at: index)
        }))
        alert.addAction(UIAlertAction(title: "Add to Current Hour Block", style: .default, handler: { (action) in
            DataGateway.shared.saveBlock(AgendaItem(title: self.items[index].title),
                                                    for: Calendar.current.component(.hour, from: Date()),
                                                    today: true)
        }))
        
        setStatusBarBackground(as: .clear)
        present(alert, animated: true, completion: nil)
    }
    
    func showAddToDoDialog(index: Int?) {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoAlert") as! AddToDoAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.delegate = self
        alert.index = index
        if index != nil {
            alert.editingTitle = items[index!].title
            alert.priority = items[index!].priority
        }
        
        setStatusBarBackground(as: .clear)
        present(alert, animated: true, completion: nil)
    }
    
    func doneButtonTapped(index: Int?, textFieldValue: String, priority: ToDoPriority) {
        self.setStatusBarBackground(as: .white)
        if index != nil { removeToDoItem(at: index!) }
        addToDoItem(title: textFieldValue, priority: priority)
    }
    
    func cancelButtonTapped() {
        setStatusBarBackground(as: .white)
    }
}

// MARK: - UI

extension ToDoViewController {
    
    func setStatusBarBackground(as color: UIColor) {
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        UIView.animate(withDuration: 0.15) {
            statusBarView.backgroundColor = color
        }
    }
}
