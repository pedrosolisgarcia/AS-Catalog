//
//  RecordsViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 23/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var gatherClientsButton: UIBarButtonItem!
    @IBOutlet weak var gatherCitiesButton: UIBarButtonItem!
    @IBOutlet weak var gatherMonthsButton: UIBarButtonItem!
    @IBOutlet weak var gatherDressesButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewClients: UITableView!
    @IBOutlet weak var tableViewCities: UITableView!
    @IBOutlet weak var tableViewMonths: UITableView!
    @IBOutlet weak var tableViewDresses: UITableView!
    @IBOutlet weak var viewClients: UIView!
    @IBOutlet weak var viewCities: UIView!
    @IBOutlet weak var viewMonths: UIView!
    @IBOutlet weak var viewDresses: UIView!
    
    @IBOutlet weak var recordSections: UISegmentedControl!
    
    var clients = [ClientMO]()
    var oldClients = [CartMO]()
    var cities = [CityMO]()
    var months = [MonthMO]()
    var dresses = [DressMO]()
    var clientsDresses = [String]()
    
    //Temporary variable to fetch client records in tableView
    weak var client: ClientMO!
    
    var fetchClientsController: NSFetchedResultsController<ClientMO>!
    var fetchCitiesController: NSFetchedResultsController<CityMO>!
    var fetchDressesController: NSFetchedResultsController<DressMO>!
    var fetchMonthsController: NSFetchedResultsController<MonthMO>!
    var fetchOldClientsController: NSFetchedResultsController<CartMO>!
    
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
        //fetchOldUsersToExportInfo()
        fetchDresses()
        fetchCities()
        fetchMonths()
        
        hideGatherButtons()
    }
    
    func hideGatherButtons() {
        gatherClientsButton.isEnabled = false
        gatherClientsButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        gatherCitiesButton.isEnabled = false
        gatherCitiesButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        gatherMonthsButton.isEnabled = false
        gatherMonthsButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        gatherDressesButton.isEnabled = false
        gatherDressesButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func fetchUsers() {
    
        //let fetchClientsRequest: NSFetchRequest<UserTestMO> = UserTestMO.fetchRequest()
        let fetchClientsRequest: NSFetchRequest<ClientMO> = ClientMO.fetchRequest()
        let sortClientsDescriptor = NSSortDescriptor(key: "fullName", ascending: true)
        fetchClientsRequest.sortDescriptors = [sortClientsDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchClientsController = NSFetchedResultsController(fetchRequest: fetchClientsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchClientsController.delegate = self
            do {
                try fetchClientsController.performFetch()
                if let fetchedClients = fetchClientsController.fetchedObjects {
                    clients = fetchedClients
                
                    //print(clients.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchOldUsersToExportInfo() {
    
        //let fetchClientsRequest: NSFetchRequest<UserTestMO> = UserTestMO.fetchRequest()
        let fetchOldClientsRequest: NSFetchRequest<CartMO> = CartMO.fetchRequest()
        let sortClientsDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchOldClientsRequest.sortDescriptors = [sortClientsDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchOldClientsController = NSFetchedResultsController(fetchRequest: fetchOldClientsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchOldClientsController.delegate = self
            do {
                try fetchOldClientsController.performFetch()
                if let fetchedOldClients = fetchOldClientsController.fetchedObjects {
                    oldClients = fetchedOldClients
                    //print(clients.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchDresses() {

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
                    
                    print(cities.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchMonths() {
        
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
        
        if tableView == tableViewClients {
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecordTableViewCell
        
        if indexPath.row < clients.count {
            client = clients[indexPath.row]
        }
        
        if tableView == tableViewClients {
            
            if indexPath.row < clients.count {
                //let client = clients[indexPath.row]
                
                cell.fullNameLabel.text = client.fullName
                //cell.fullNameLabel.text = client.name! + " " + client.lastname!
                cell.emailLabel.text = client.email?.lowercased()
                cell.phoneLabel.text = client.phone
                cell.clientCount.text = ""
            }
            else {
                cell.fullNameLabel.text = ""
                cell.emailLabel.text = ""
                cell.phoneLabel.text = ""
                cell.clientCount.text = "Total amount of clients: " + String(describing: clients.count)
            }
        }
        if tableView == tableViewCities {
            let city = cities[indexPath.row]
            
            cell.cityLabel.text = city.name
            cell.cityCount.text = String(describing: city.count)
            //cell.cityLabel.text = client.city
        }
        if tableView == tableViewMonths {
            //let month = months[indexPath.row]
            //let month = oldClients[indexPath.row]
            //cell.monthLabel.text = month.month
            //cell.monthCount.text = String(describing: month.count)
            //cell.monthLabel.text = month.weddingDate
        }
        if tableView == tableViewDresses {
            let dress = dresses[indexPath.row]
            
            cell.dressLabel.text = dress.name
            cell.dressCount.text = String(describing: dress.count)
            //  cell.dressLabel.text = client.dresses?.componentsJoined(by: ", ")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == tableViewClients {
            if editingStyle == .delete {
                
                clients.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if tableView == tableViewCities {
            if editingStyle == .delete {
                
                cities.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if tableView == tableViewMonths {
            if editingStyle == .delete {
                
                months.remove(at: indexPath.row)
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
            }
        case .delete:
            if let indexPath = indexPath {
                tableViewClients.deleteRows(at: [indexPath], with: .fade)
                tableViewCities.deleteRows(at: [indexPath], with: .fade)
                tableViewMonths.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableViewClients.reloadRows(at: [indexPath], with: .fade)
                tableViewCities.reloadRows(at: [indexPath], with: .fade)
                tableViewMonths.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableViewClients.reloadData()
            tableViewCities.reloadData()
            tableViewMonths.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            //clients = fetchedObjects as! [UserTestMO]
            //clients = fetchedObjects as! [CartMO]
            clients = fetchedObjects as! [ClientMO]
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
    
    @IBAction func gatherDresses(_ sender: UIBarButtonItem) {
        
        for client in oldClients {
            for dress in client.dresses! {
                clientsDresses.append(dress as! String)
            }
        }
        print(clientsDresses.count)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            for dress in dresses {
                let countDress = clientsDresses.filter{$0 == dress.name}.count
                print(dress.name! + ": " + String(describing: countDress))
                dress.count = Int32(countDress)
                appDelegate.saveContext()
            }
        }
    }
    @IBAction func gatherClients(_ sender: UIBarButtonItem) {
     
        for client in oldClients {
     
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
     
                let clientToAdd = ClientMO(context: appDelegate.persistentContainer.viewContext)
                clientToAdd.fullName = client.name! + " " + client.lastname!
                clientToAdd.email = client.email
                clientToAdd.phone = client.phone
                print(clientToAdd)
                appDelegate.saveContext()
            }
        }
     }
    @IBAction func gatherCities(_ sender: UIBarButtonItem) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            for city in cities {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(city)
                appDelegate.saveContext()
            }
        }
        var oldCities = [String]()
        for client in oldClients {
            oldCities.append(client.city!)
        }
        var counts: [String: Int] = [:]
        oldCities.forEach { counts[$0, default: 0] += 1 }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            for count in counts {
                let newCity = CityMO(context: appDelegate.persistentContainer.viewContext)
                newCity.name = count.key
                newCity.count = Int32(count.value)
                print(newCity)
                cities.append(newCity)
                appDelegate.saveContext()
            }
        }
    }
    
    @IBAction func exportButton(_ sender: UIBarButtonItem) {
    
        let emailViewController = saveAndExportByMail()
        if MFMailComposeViewController.canSendMail() {
            self.present(emailViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    func saveAndExportByMail() -> MFMailComposeViewController {
        
        let emailController = MFMailComposeViewController()
        let dataClients = createExportClientsString()
        let dataCities = createExportCitiesString()
        let dataMonths = createExportMonthsString()
        let dataDresses = createExportDressesString()
        
        emailController.mailComposeDelegate = self
        emailController.setSubject("Extracted data from iPad App")
        emailController.setMessageBody("", isHTML: false)
        
        emailController.addAttachmentData(dataClients, mimeType: "text/csv", fileName: "Clients.csv")
        emailController.addAttachmentData(dataCities, mimeType: "text/csv", fileName: "Cities.csv")
        emailController.addAttachmentData(dataMonths, mimeType: "text/csv", fileName: "Months.csv")
        emailController.addAttachmentData(dataDresses, mimeType: "text/csv", fileName: "Dresses.csv")
        
        return emailController
    }
    
    /*func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }*/
    
    func createExportClientsString() -> Data {
        
        var fullNameVar: String!
        var emailVar: String!
        var phoneVar: String!
        var export: String = NSLocalizedString("Name and Lastname, Email, Phone\n", comment: "")
        
        for client in clients {
            
            fullNameVar = client.fullName
            emailVar = client.email
            phoneVar = client.phone
            export += "\(fullNameVar!),\(emailVar!),\(phoneVar!) \n"
        }
        let convertingExportToNSData = export.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        return convertingExportToNSData!
    }
    
    func createExportCitiesString() -> Data {
        
        var cityVar: String!
        var cityCountVar: Int32!
        var export: String = NSLocalizedString("City, Amount\n", comment: "")
        
        for city in cities {
            
            cityVar = city.name
            cityCountVar = city.count
            export += "\(cityVar!),\(String(describing: cityCountVar!)) \n"
        }
        let convertingExportToNSData = export.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        return convertingExportToNSData!
    }
    
    func createExportMonthsString() -> Data {
        
        var monthVar: String!
        var monthCountVar: Int32?
        var export: String = NSLocalizedString("Month, Month Amount\n", comment: "")
        
        for month in months {
            
            monthVar = month.month
            monthCountVar = month.count
            export += "\(monthVar!),\(String(describing: monthCountVar!)) \n"
        }
        let convertingExportToNSData = export.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        return convertingExportToNSData!
    }
    
    func createExportDressesString() -> Data {
        
        var dressVar: String!
        var dressCountVar: Int32?
        var export: String = NSLocalizedString("Dress, Dress Amount\n", comment: "")
        
        for dress in dresses {
            
            dressVar = dress.name
            dressCountVar = dress.count
            export += "\(dressVar!),\(String(describing: dressCountVar!)) \n"
        }
        let convertingExportToNSData = export.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        return convertingExportToNSData!
    }
}
