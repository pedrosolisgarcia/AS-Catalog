import Foundation
import UIKit
import CoreData

public class CoreDataManager {
    
    class func fetchCustomersFromCoreData(delegate: NSFetchedResultsControllerDelegate) -> [CustomerMO] {
        var fetchDataController: NSFetchedResultsController<CustomerMO>!
        var customers = [CustomerMO]()
        let fetchDressesRequest: NSFetchRequest<CustomerMO> = CustomerMO.fetchRequest()
        let sortDressesDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchDressesRequest.sortDescriptors = [sortDressesDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchDataController = NSFetchedResultsController(fetchRequest: fetchDressesRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchDataController.delegate = delegate
            do {
                try fetchDataController.performFetch()
                if let fetchedData = fetchDataController.fetchedObjects {
                    customers = fetchedData
                }
            } catch {
                print(error)
            }
        }
        return customers
    }
    
    class func saveCustomerInCoreData(customer: Customer, viewContext: NSManagedObjectContext) {
        let costumerMO = CustomerMO(context: viewContext)
        costumerMO.name = customer.name
        costumerMO.surname = customer.surname
        costumerMO.region = customer.region
        costumerMO.dateOfWedding = customer.dateOfWedding
        costumerMO.dressesNames = customer.dressesNames
    }
}
