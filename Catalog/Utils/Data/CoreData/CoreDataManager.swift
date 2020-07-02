import Foundation
import UIKit
import CoreData

public class CoreDataManager {
  
  class func getCustomersFromCoreData(delegate: NSFetchedResultsControllerDelegate) -> [CustomerMO] {
    var customers = [Any]()
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      let context = appDelegate.persistentContainer.viewContext
      let getCustomersRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomerMO")
      getCustomersRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
      do {
        let getedData = try context.fetch(getCustomersRequest)
        customers = getedData

      } catch let error as NSError {
        print(error)
      }
    }
    return customers as! [CustomerMO]
  }
  
  class func saveCustomerInCoreData(customer: Customer, viewContext: NSManagedObjectContext) {
    let customerEntity = NSEntityDescription.entity(forEntityName: "CustomerMO", in: viewContext)
    let customerObject = NSManagedObject(entity: customerEntity!, insertInto: viewContext)
    customerObject.setValue(customer.appVersion, forKey: "appVersion")
    customerObject.setValue(customer.dateOfVisit, forKey: "dateOfVisit")
    customerObject.setValue(customer.shopId, forKey: "shopId")
    customerObject.setValue(customer.name, forKey: "name")
    customerObject.setValue(customer.surname, forKey: "surname")
    customerObject.setValue(customer.region, forKey: "region")
    customerObject.setValue(customer.dateOfWedding, forKey: "dateOfWedding")
    customerObject.setValue(customer.dressesNames, forKey: "dressesNames")
    customerObject.setValue(customer.collectionId, forKey: "collectionId")
    
    do {
      try viewContext.save()

    } catch let error as NSError {
      print(error)
    }
  }
}
