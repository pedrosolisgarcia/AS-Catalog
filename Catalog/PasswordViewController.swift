//
//  PasswordViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 27/12/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class PasswordViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterRecords: UIButton!
    
    var passwords = [PasswordMO]()
    
    var fetchPasswordController: NSFetchedResultsController<PasswordMO>!

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.removeFromSuperview()
        fetchPassword()
        self.showAnimate()
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
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func unwindToPassword(segue:UIStoryboardSegue){}
    
    @IBAction func closeWindow(sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBAction func checkPassword(sender: UIButton) {
        
        /*if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let pass = PasswordMO(context: appDelegate.persistentContainer.viewContext)
            pass.password = "555555"
            print(pass.password)
            appDelegate.saveContext()
        }*/
        
        if passwordField.text == passwords[0].password {
            self.performSegue(withIdentifier: "showRecords", sender: self)
            self.view.removeFromSuperview()
        }
        else {
            let alertController = UIAlertController(title: "Wrong password", message: "The password introduced is incorrect. Please try again.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
        let popChangePasswordView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changePasswordView") as! ChangePasswordViewController
        self.addChildViewController(popChangePasswordView)
        popChangePasswordView.view.frame = self.view.frame
        self.view.addSubview(popChangePasswordView.view)
        popChangePasswordView.didMove(toParentViewController: self)
    }
    
    func showAnimate() {
        
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
        });
    }
}
