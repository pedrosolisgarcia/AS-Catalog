//
//  HomeViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 29/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var beforeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var hometownField: UITextField!
    @IBOutlet weak var createProfileButton: UIButton!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var lowSeparator: UIView!
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var catalogButton: UIButton!
    
    var fields: [Bool] = [false,false,false,false,false]
    //var cart: cart = cart(name: "", lastname: "", email: "", phone: "", hometown: "")
    var provCart: Cart = Cart(name: "", lastname: "", email: "", phone: "", city: "", dresses: [""])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
        lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        catalogButton.isEnabled = false
        catalogButton.alpha = 0
        
        hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func createProfile(sender: UIButton) {
        if nameField.text == "" || lastnameField.text == "" || emailField.text == "" || hometownField.text == "" {
            let alertController = UIAlertController(title: "Błąd", message: "Wszystkie pola muszą być wypełnione, aby zobaczyć katalog.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dobra", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        } else {
            provCart.name = nameField.text!
            provCart.lastname = lastnameField.text!
            provCart.email = emailField.text!
            provCart.phone = phoneField.text!
            provCart.city = hometownField.text!
            
            lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            catalogButton.isEnabled = true
            catalogButton.alpha = 1
        }
        dismissKeyboard()
    }
    
    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showCatalog"{
            
            let destinationController = segue.destination as! CatalogViewController
            destinationController.provCart = provCart
        }
    }
    
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() { view.endEditing(true) }
}
