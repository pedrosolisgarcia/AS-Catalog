//
//  ChangePasswordViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 27/12/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class ChangePasswordViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var repeatNewPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    
    var passwords = [PasswordMO]()
    var password: PasswordMO!
    
    var fetchPasswordController: NSFetchedResultsController<PasswordMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchPassword() {
        
        let fetchPasswordRequest: NSFetchRequest<PasswordMO> = PasswordMO.fetchRequest()
        let sortPasswordDescriptor = NSSortDescriptor(key: "password", ascending: true)
        fetchPasswordRequest.sortDescriptors = [sortPasswordDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchPasswordController = NSFetchedResultsController(fetchRequest: fetchPasswordRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchPasswordController.delegate = self
            do {
                try fetchPasswordController.performFetch()
                if let fetchedPassword = fetchPasswordController.fetchedObjects {
                    passwords = fetchedPassword
                    password = passwords[0]
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func confirmPassword(sender: UIButton) {
        
        if oldPasswordField.text == password.password {
            
            if newPasswordField.text == repeatNewPasswordField.text {
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    self.passwords[0].password = self.newPasswordField.text
                    appDelegate.saveContext()
                }
                let alertController = UIAlertController(title: "Success", message: "The password has been changed.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
                    self.performSegue(withIdentifier: "unwindToPassword", sender: self)
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion:nil)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "The new passwords don't match. Please try again", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion:nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "Wrong password", message: "The password introduced is incorrect. Please try again.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        }
    }
}
