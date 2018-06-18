//
//  SelectCountryViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 30/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class SelectCountryViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var languageIndex: Int!
    
    var selectedCountry = ""
    var headerLang = ["KRAJ POCHODZENIA","COUNTRY SELECTION","SELECCIÓN DE PAÍS"]
    var cancelLang = ["Anuluj","Cancel","Cancelar"]
    var confirmLang = ["Zrobione","Confirm","Hecho"]
    var otherLang = ["Inne","Other","Otro"]
    var countryLang = ["Kraj:","Country:","País:"]
    var countries = [
        ["Niemcy", "Anglia", "Czechy", "Rosja", "Ukraina"],
        ["Germany", "England", "Czech Republic", "Russia", "Ukraine"],
        ["Alemania", "Inglaterra", "República Checa", "Rusia", "Ukrania"]]
    weak var delegate: HomeViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        self.isEditing = false
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
        self.showAnimate()
        headerLabel.text = headerLang[languageIndex]
        cancelButton.setTitle(cancelLang[languageIndex], for: .normal)
        otherLabel.text = otherLang[languageIndex]
        countryLabel.text = countryLang[languageIndex]
        confirmButton.setTitle(confirmLang[languageIndex], for: .normal)
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
        
        let maskPathSave = UIBezierPath(roundedRect: confirmButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerSave = CAShapeLayer()
        maskLayerSave.path = maskPathSave.cgPath
        confirmButton.layer.mask = maskLayerSave
        
        let maskPathLabel = UIBezierPath(roundedRect: headerLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerLabel = CAShapeLayer()
        maskLayerLabel.path = maskPathLabel.cgPath
        headerLabel.layer.mask = maskLayerLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! SelectCountryTableViewCell
        tableView.separatorColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        let country = countries[languageIndex][indexPath.row]
        
        cell.countryLabel.text = country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = countries[languageIndex][indexPath.row]
        confirmButton.isEnabled = true
        confirmButton.alpha = 1
        countryField.text = ""
        print(selectedCountry)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text?.count)! < 3 {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
        } else {
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count)! < 3 {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
        } else {
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
        }
    }
    
    func showAnimate() {
        
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @IBAction func removeAnimate(sender: UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                if sender == self.confirmButton {
                    if self.selectedCountry == "" {
                        self.selectedCountry = self.countryField.text!
                    }
                    self.delegate.regionLabel.text = self.countryLang[self.languageIndex]
                    self.delegate.setCountryField(country: self.selectedCountry)
                }
                if sender == self.cancelButton {
                    self.delegate.setCountryField(country: "")
                }
                if (self.delegate.view.gestureRecognizers?.isEmpty)! {
                    self.delegate.hideKeyboard()
                }
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
        });
    }
}
