//
//  RecordsViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 23/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableViewClients: UITableView!
    @IBOutlet weak var tableViewCities: UITableView!
    @IBOutlet weak var tableViewMonths: UITableView!
    @IBOutlet weak var tableViewDresses: UITableView!
    @IBOutlet weak var viewClients: UIView!
    @IBOutlet weak var viewCities: UIView!
    @IBOutlet weak var viewMonths: UIView!
    @IBOutlet weak var viewDresses: UIView!
    
    @IBOutlet weak var recordSections: UISegmentedControl!
    
    //var clients = [UserTestMO]()
    var clients = [CartMO]()
    var cities = [CityMO]()
    var months = [MonthMO]()
    var dresses = [DressMO]()
    
    var fetchCitiesController: NSFetchedResultsController<CityMO>!
    var fetchDressesController: NSFetchedResultsController<DressMO>!
    var fetchMonthsController: NSFetchedResultsController<MonthMO>!
    //var fetchClientsController: NSFetchedResultsController<UserTestMO>!
    var fetchClientsController: NSFetchedResultsController<CartMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewClients.isHidden = false
        tableViewCities.isHidden = true
        tableViewMonths.isHidden = true
        tableViewDresses.isHidden = true
        viewClients.isHidden = false
        viewCities.isHidden = true
        viewMonths.isHidden = true
        viewDresses.isHidden = true
        
        fetchUsers()
        fetchDresses()
        fetchCities()
        fetchMonths()
    }
    
    func fetchUsers() {
        print("Starting to fetch users...")
        //let fetchClientsRequest: NSFetchRequest<UserTestMO> = UserTestMO.fetchRequest()
        let fetchClientsRequest: NSFetchRequest<CartMO> = CartMO.fetchRequest()
        let sortClientsDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchClientsRequest.sortDescriptors = [sortClientsDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchClientsController = NSFetchedResultsController(fetchRequest: fetchClientsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchClientsController.delegate = self
            do {
                try fetchClientsController.performFetch()
                if let fetchedClients = fetchClientsController.fetchedObjects {
                    clients = fetchedClients
                    print("Users fetched!")
                    //print(clients.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchDresses() {
        print("Starting to fetch dresses...")
        let fetchDressesRequest: NSFetchRequest<DressMO> = DressMO.fetchRequest()
        let sortDressesDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchDressesRequest.sortDescriptors = [sortDressesDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchDressesController = NSFetchedResultsController(fetchRequest: fetchDressesRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchDressesController.delegate = self
            do {
                try fetchDressesController.performFetch()
                if let fetchedDresses = fetchDressesController.fetchedObjects {
                    dresses = fetchedDresses
                    print("Dresses fetched!")
                    for dress in dresses {
                        print(dress.name! + ": " + String(describing: dress.count))
                    }
                    print(dresses.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchCities() {
        print("Starting to fetch cities...")
        let fetchCitiesRequest: NSFetchRequest<CityMO> = CityMO.fetchRequest()
        let sortCitiesDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchCitiesRequest.sortDescriptors = [sortCitiesDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchCitiesController = NSFetchedResultsController(fetchRequest: fetchCitiesRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchCitiesController.delegate = self
            
            do {
                try fetchCitiesController.performFetch()
                if let fetchedCities = fetchCitiesController.fetchedObjects {
                    cities = fetchedCities
                    print("Cities fetched!")
                    //print(cities[0].name!)
                    print(cities.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchMonths() {
        print("Starting to fetch months...")
        let fetchMonthsRequest: NSFetchRequest<MonthMO> = MonthMO.fetchRequest()
        let sortMonthsDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchMonthsRequest.sortDescriptors = [sortMonthsDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchMonthsController = NSFetchedResultsController(fetchRequest: fetchMonthsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchMonthsController.delegate = self
            do {
                try fetchMonthsController.performFetch()
                if let fetchedMonths = fetchMonthsController.fetchedObjects {
                    months = fetchedMonths
                    print("Months fetched!")
                    print(months[0].month!)
                    print(months.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch recordSections.selectedSegmentIndex {
        case 0:
            tableViewClients.isHidden = false
            tableViewCities.isHidden = true
            tableViewMonths.isHidden = true
            tableViewDresses.isHidden = true
            viewClients.isHidden = false
            viewCities.isHidden = true
            viewMonths.isHidden = true
            viewDresses.isHidden = true
        case 1:
            tableViewClients.isHidden = true
            tableViewCities.isHidden = false
            tableViewMonths.isHidden = true
            tableViewDresses.isHidden = true
            viewClients.isHidden = true
            viewCities.isHidden = false
            viewMonths.isHidden = true
            viewDresses.isHidden = true
        case 2:
            tableViewClients.isHidden = true
            tableViewCities.isHidden = true
            tableViewMonths.isHidden = false
            tableViewDresses.isHidden = true
            viewClients.isHidden = true
            viewCities.isHidden = true
            viewMonths.isHidden = false
            viewDresses.isHidden = true
        case 3:
            tableViewClients.isHidden = true
            tableViewCities.isHidden = true
            tableViewMonths.isHidden = true
            tableViewDresses.isHidden = false
            viewClients.isHidden = true
            viewCities.isHidden = true
            viewMonths.isHidden = true
            viewDresses.isHidden = false
        default:
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if tableView == tableViewClients {
            return clients.count + 1
        }
        if tableView == tableViewCities {
            return cities.count
        }
        if tableView == tableViewMonths {
            return months.count
        }
        if tableView == tableViewDresses {
            return dresses.count
        }
        else {
            return 1
        }*/
        if tableView == tableViewClients {
            return clients.count + 1
        } else {
            return clients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecordTableViewCell
        
        let client = clients[indexPath.row]
        
        if tableView == tableViewClients {
            
            if indexPath.row < clients.count {
                //let client = clients[indexPath.row]
                
                //cell.fullNameLabel.text = client.fullName
                cell.fullNameLabel.text = client.name! + " " + client.lastname!
                cell.emailLabel.text = client.email?.lowercased()
                cell.phoneLabel.text = client.phone
            }
            else {
                cell.clientCount.text = "Total amount of clients: " + String(describing: clients.count)
            }
        }
        if tableView == tableViewCities {
            /*let city = cities[indexPath.row]
            
            cell.cityLabel.text = city.name
            cell.cityCount.text = String(describing: city.count)*/
            cell.cityLabel.text = client.city
        }
        if tableView == tableViewMonths {
            /*let month = months[indexPath.row]
            
            cell.monthLabel.text = month.month
            cell.monthCount.text = String(describing: month.count)*/
            
        }
        if tableView == tableViewDresses {
            /*let dress = dresses[indexPath.row]
            
            cell.dressLabel.text = dress.name
            cell.dressCount.text = String(describing: dress.count)*/
            cell.dressLabel.text = client.dresses?.componentsJoined(by: ",")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == tableViewClients {
            if editingStyle == .delete {
                // Delete the row from the data source
                clients.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if tableView == tableViewCities {
            if editingStyle == .delete {
                // Delete the row from the data source
                cities.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if tableView == tableViewMonths {
            if editingStyle == .delete {
                // Delete the row from the data source
                months.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if tableView == tableViewDresses {
            if editingStyle == .delete {
                // Delete the row from the data source
                dresses.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                
                if tableView == self.tableViewClients {
                    let clientToDelete = self.fetchClientsController.object(at: indexPath)
                    context.delete(clientToDelete)
                }
                if tableView == self.tableViewCities {
                    let cityToDelete = self.fetchCitiesController.object(at: indexPath)
                    context.delete(cityToDelete)
                }
                if tableView == self.tableViewMonths {
                    let monthToDelete = self.fetchMonthsController.object(at: indexPath)
                    context.delete(monthToDelete)
                }
                if tableView == self.tableViewDresses {
                    let dressToDelete = self.fetchDressesController.object(at: indexPath)
                    context.delete(dressToDelete)
                }
                appDelegate.saveContext()
            }
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewClients.beginUpdates()
        tableViewCities.beginUpdates()
        tableViewMonths.beginUpdates()
        tableViewDresses.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableViewClients.insertRows(at: [newIndexPath], with: .fade)
                tableViewCities.insertRows(at: [newIndexPath], with: .fade)
                tableViewMonths.insertRows(at: [newIndexPath], with: .fade)
                tableViewDresses.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableViewClients.deleteRows(at: [indexPath], with: .fade)
                tableViewCities.deleteRows(at: [indexPath], with: .fade)
                tableViewMonths.deleteRows(at: [indexPath], with: .fade)
                tableViewDresses.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableViewClients.reloadRows(at: [indexPath], with: .fade)
                tableViewCities.reloadRows(at: [indexPath], with: .fade)
                tableViewMonths.reloadRows(at: [indexPath], with: .fade)
                tableViewDresses.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableViewClients.reloadData()
            tableViewCities.reloadData()
            tableViewMonths.reloadData()
            tableViewDresses.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            //clients = fetchedObjects as! [UserTestMO]
            clients = fetchedObjects as! [CartMO]
            cities = fetchedObjects as! [CityMO]
            months = fetchedObjects as! [MonthMO]
            dresses = fetchedObjects as! [DressMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewClients.endUpdates()
        tableViewCities.endUpdates()
        tableViewMonths.endUpdates()
        tableViewDresses.endUpdates()
    }
    
    @IBAction func exportButton(_ sender: UIButton) {
        print("Preparing to exportDatabase...")
        exportDatabase()
        print("Function exportDatabase called")    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func exportDatabase() {
        
        if !tableViewClients.isHidden {
            print("Current tab: Clients. Preparing to saveAndExport...")
            let exportClientsString = createExportClientsString()
            saveAndExport(exportString: exportClientsString)
            print("Function exportToDatabase called")
        }
        if !tableViewCities.isHidden {
            print("Current tab: Cities. Preparing to saveAndExport...")
            let exportCitiesString = createExportCitiesString()
            saveAndExport(exportString: exportCitiesString)
            print("Function exportToDatabase called")
        }
        if !tableViewMonths.isHidden {
            print("Current tab: Months. Preparing to saveAndExport...")
            let exportMonthsString = createExportMonthsString()
            saveAndExport(exportString: exportMonthsString)
            print("Function exportToDatabase called")
        }
        if !tableViewDresses.isHidden {
            print("Current tab: Dresses. Preparing to saveAndExport...")
            let exportDressesString = createExportDressesString()
            saveAndExport(exportString: exportDressesString)
            print("Function exportToDatabase called")
        }
    }
    
    func saveAndExport(exportString: String) {
        print("Preparing export file path...")
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
    
    func createExportClientsString() -> String {
        
        var fullNameVar: String!
        var emailVar: String!
        var phoneVar: String?
        
        var export: String = NSLocalizedString("Name and Lastname, Email, Phone\n", comment: "")
        for client in clients {
            
            //fullNameVar = client.fullName
            fullNameVar = client.name! + " " + client.lastname!
            emailVar = client.email
            phoneVar = client.phone
            
            export += "\(fullNameVar),\(emailVar!),\(String(describing: phoneVar)) \n"
            
        }
        print("These are the clients the app will export:\n \(export)")
        return export
    }
    
    func createExportCitiesString() -> String {
        
        var cityVar: String!
        var cityCountVar: Int32?
        
        var export: String = NSLocalizedString("City, Amount\n", comment: "")
        for city in cities {
            
            cityVar = city.name
            cityCountVar = city.count
            
            export += "\(cityVar),\(String(describing: cityCountVar)) \n"
            
        }
        print("These are the cities the app will export:\n \(export)")
        return export
    }
    
    func createExportMonthsString() -> String {
        
        var monthVar: String!
        var monthCountVar: Int32?
        
        var export: String = NSLocalizedString("Month, Amount\n", comment: "")
        for month in months {
            
            monthVar = month.month
            monthCountVar = month.count
            
            export += "\(monthVar),\(String(describing: monthCountVar)) \n"
            
        }
        print("These are the months the app will export:\n \(export)")
        return export
    }
    
    func createExportDressesString() -> String {
        
        var dressVar: String!
        var dressCountVar: Int32?
        
        var export: String = NSLocalizedString("Dress, Amount\n", comment: "")
        for dress in dresses {
            
            dressVar = dress.name
            dressCountVar = dress.count
            
            export += "\(dressVar),\(String(describing: dressCountVar)) \n"
            
        }
        print("These are the dresses the app will export:\n \(export)")
        return export
    }
}
