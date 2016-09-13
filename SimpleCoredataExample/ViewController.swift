//
//  ViewController.swift
//  SimpleCoredataExample
//
//  Created by Flávio Silvério on 13/09/16.
//  Copyright © 2016 Flávio Silvério. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var managedObjectContext : NSManagedObjectContext?
    var allPersons = [Person]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loadAllPersons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Editing the name
    
    func editNameAtIndex(index: IndexPath){
    
        let oldName = self.allPersons[index.row].name!
        
        let alert = UIAlertController(title: "Edit \(oldName)", message: "Please insert the new name for the person previously known as \(oldName)", preferredStyle: .alert)
    
        alert.addTextField {
            (textField: UITextField!) in
            textField.text = oldName
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
         action in
            
            self.allPersons[index.row].name = alert.textFields?[0].text
            self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: {
        
        })
        
    }

    //MARK: Table View Data source methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
        
        (cell.viewWithTag(101) as! UILabel).text = allPersons[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPersons.count
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
        
            self.managedObjectContext?.delete(self.allPersons[indexPath.row])
            self.allPersons.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        }
        delete.backgroundColor = UIColor.red

        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
            self.editNameAtIndex(index: indexPath)
            
        }
        edit.backgroundColor = UIColor.gray
        
        return [delete, edit]
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: CoreData Methods
    
    func addPerson(withName name: String, inContext context: NSManagedObjectContext){
    
        let person = Person(context: context)
        person.name = name
    
    }
    

    func loadAllPersons(){
    
        let request : NSFetchRequest<Person> = Person.fetchRequest()
        do {
            allPersons = try (managedObjectContext?.fetch(request))!
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        } catch {
            print("Error with request: \(error)")
        }

        
    }
    
    
    //MARK: Actions
    
    @IBAction func addPerson(_ sender: AnyObject) {
        
        self.addPerson(
            withName: (nameField.text?.characters.count)! > 0 ?
                nameField.text! : "No Name",
            inContext: managedObjectContext!)
        
        self.loadAllPersons()
    }
    
    @IBAction func add1000RandomPersons(_ sender: AnyObject) {
        
        let names = ["Flavio", "Daniel", "Almeida", "Silverio","Carlos", "Luke", "Skywalker", "Han", "Leia", "Mariane", "Hemma", "Josh", "Paul", "Raul"]
        let localContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        localContext.parent = managedObjectContext
        
        localContext.perform {
            
            for _ in 0...10000 {
                
                let firstName = arc4random_uniform(UInt32(names.count))
                let secondName = arc4random_uniform(UInt32(names.count))
                let name = "\(names[Int(firstName)]) \(names[Int(secondName)])"
                
                self.addPerson(withName: name, inContext: localContext)
            }
            
            do {
                try localContext.save()
                self.loadAllPersons()

                
            } catch {
                print("Error with request: \(error)")
            }
            
            
        }
    
    
    }
    
    @IBAction func share(_ sender: AnyObject) {
        
        let shareAction = UIActivityViewController(activityItems: ["Items to share go in this array, they can be anything"], applicationActivities: nil)
        self.present(shareAction, animated: true, completion: nil)
    }
    
}

