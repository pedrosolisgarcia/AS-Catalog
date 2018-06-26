import Foundation
import UIKit
import CoreData

public class CoreDataManager {
    
    class func fetchCustomersFromCoreData(delegate: NSFetchedResultsControllerDelegate) {
        var fetchDataController: NSFetchedResultsController<CartMO>!
        var carts = [CartMO]()
        let fetchDressesRequest: NSFetchRequest<CartMO> = CartMO.fetchRequest()
        let sortDressesDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchDressesRequest.sortDescriptors = [sortDressesDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchDataController = NSFetchedResultsController(fetchRequest: fetchDressesRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchDataController.delegate = delegate
            do {
                try fetchDataController.performFetch()
                if let fetchedData = fetchDataController.fetchedObjects {
                    carts = fetchedData
                }
            } catch {
                print(error)
            }
        }
        
        for cart in carts {
            print(cart.name! + " " + cart.surname!)
            print(" " + cart.region! + " " + cart.dateOfWedding!)
        }
    }
    
    class func saveCustomerInCoreData(provCart: Cart, viewContext: NSManagedObjectContext) {
        let cart = CartMO(context: viewContext)
        cart.name = provCart.name
        cart.surname = provCart.surname
        cart.region = provCart.region
        cart.dateOfWedding = provCart.dateOfWedding
        cart.dressesNames = (provCart.dressesNames as NSArray).componentsJoined(by: ",")
    }
}
