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
	
    @IBOutlet weak var collectionView: UICollectionView!
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
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                print("Hey, Siri!")
            } else {
                print("Nay, Siri!")
            }
        }
    }
	
    @IBAction func addButtonPressed(_ sender: Any) {
        showAddToDoDialog()
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
        
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    func removeToDoItem(at index: Int) {
        DataGateway.shared.deleteToDo(item: items[index])
        items.remove(at: index)
        
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
}

// MARK: - Collection View

extension ToDoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toDoBlockCell", for: indexPath) as? ToDoBlockCell else { return UICollectionViewCell() }
		cell.build(with: items[indexPath.row])
		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showToDoOptionsDialog(for: indexPath.row)
    }
}

// MARK: - Dialogs

extension ToDoViewController: AddToDoDelegate {
    
    func showToDoOptionsDialog(for index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            // TODO Edit
        }))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            self.removeToDoItem(at: index)
        }))
        
        setStatusBarBackground(as: .clear)
        present(alert, animated: true, completion: nil)
    }
    
    func showAddToDoDialog() {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoAlert") as! AddToDoAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.delegate = self
        
        setStatusBarBackground(as: .clear)
        present(alert, animated: true, completion: nil)
    }
    
    func doneButtonTapped(textFieldValue: String, priority: ToDoPriority) {
        self.setStatusBarBackground(as: .white)
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
