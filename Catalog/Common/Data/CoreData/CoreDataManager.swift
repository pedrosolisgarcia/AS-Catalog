//
//  CoreDataManager.swift
//  Catalog
//
//  Created by Pedro Solís García on 06/26/18.
//  Copyright © 2018 VILHON Technologies. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataManager {
    
    class func getClientsFromCoreData(delegate: NSFetchedResultsControllerDelegate) -> [ClientMO] {
        var clients = [Any]()
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            let getClientsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ClientMO")
            getClientsRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
            do {
                let getedData = try context.fetch(getClientsRequest)
                clients = getedData
                
            } catch let error as NSError {
                print(error)
            }
        }
        return clients as! [ClientMO]
    }
    
    class func saveClientInCoreData(client: Client, viewContext: NSManagedObjectContext) -> Void {
        let clientEntity = NSEntityDescription.entity(forEntityName: "ClientMO", in: viewContext)
        let clientObject = NSManagedObject(entity: clientEntity!, insertInto: viewContext)
        clientObject.setValue(client.appVersion, forKey: "appVersion")
        clientObject.setValue(client.dateOfVisit, forKey: "dateOfVisit")
        clientObject.setValue(client.shopId, forKey: "shopId")
        clientObject.setValue(client.name, forKey: "name")
        clientObject.setValue(client.surname, forKey: "surname")
        clientObject.setValue(client.region, forKey: "region")
        clientObject.setValue(client.dateOfWedding, forKey: "dateOfWedding")
        clientObject.setValue(client.dressesNames, forKey: "dressesNames")
        clientObject.setValue(client.collectionId, forKey: "collectionId")
        
        do {
            try viewContext.save()
            print("Saved Successfully in CoreData")
            
        } catch let error as NSError {
            print(error)
        }
    }
}
