//
//  RecordsTableViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 23/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class RecordsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var records: [CartMO] = []
    var fetchResultController: NSFetchedResultsController<CartMO>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest: NSFetchRequest<CartMO> = CartMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    records = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecordTableViewCell

        let record = records[indexPath.row]
        
        cell.nameLabel.text = record.name
        cell.lastnameLabel.text = record.lastname
        cell.emailLabel.text = record.email
        cell.phoneLabel.text = record.phone
        cell.cityLabel.text = record.city
        cell.weddingDateLabel.text = record.weddingDate
        cell.dressesLabel.text = record.dresses?.componentsJoined(by: ", ")
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            records.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let recordToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(recordToDelete)
                
                appDelegate.saveContext()
            }
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            records = fetchedObjects as! [CartMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBAction func exportButton(_ sender: UIButton) {
        exportDatabase()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func exportDatabase() {
        let exportString = createExportString()
        saveAndExport(exportString: exportString)
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "record.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func createExportString() -> String {

        var nameVar: String?
        var lastnameVar: String?
        var emailVar: String?
        var phoneVar: NSNumber?
        var cityVar: String?
        var weddingDateVar: String?
        var dressesVar: [String]?
        
        var export: String = NSLocalizedString("itemID, productName, Amount \n", comment: "")
        for (index, record) in records.enumerated() {
            if index <= records.count - 1 {
                nameVar = record.value(forKey: "name") as! String?
                lastnameVar = record.value(forKey: "lastname") as! String?
                emailVar = record.value(forKey: "email") as! String?
                phoneVar = record.value(forKey: "phone") as! NSNumber?
                cityVar = record.value(forKey: "city") as! String?
                weddingDateVar = record.value(forKey: "wedding date") as! String?
                dressesVar = record.value(forKey: "dresses") as! [String]?
                
                export += "\(String(describing: nameVar)),\(String(describing: lastnameVar)),\(emailVar!),\(String(describing: phoneVar)),\(String(describing: cityVar)),\(String(describing: weddingDateVar)),\(String(describing: dressesVar)) \n"
            }
        }
        print("This is what the app will export: \(export)")
        return export
    }
}
