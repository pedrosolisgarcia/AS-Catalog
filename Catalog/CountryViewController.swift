//
//  CountryViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 29/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var polishButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    var languageIndex: Int!
    
    var selectedCountry = ""
    var headerLang = ["KRAJ POCHODZENIA","COUNTRY SELECTION","SELECCIÓN DE PAÍS"]
    var countryLang = ["Skąd jesteś?","Where are you from?","De dónde eres?"]
    var polishLang = ["Z POLSKI","FROM POLAND","DE POLONIA"]
    var otherLang = ["INNE","OTHER","OTRO"]
    
    @IBAction func unwindToCountryScreen(segue:UIStoryboardSegue){
        if segue.identifier == "countrySelected" {
            self.performSegue(withIdentifier: "applyCountry", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showAnimate()
        headerLabel.text = headerLang[languageIndex]
        countryLabel.text = countryLang[languageIndex]
        polishButton.setTitle(polishLang[languageIndex], for: .normal)
        otherButton.setTitle(otherLang[languageIndex], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                if sender == self.polishButton {
                    self.performSegue(withIdentifier: "unwindToPolishRegion", sender: self)
                }
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
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
    
    @IBAction func showCountrySelector(sender: UIButton) {
        
        let popCountrySelectorView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountrySelectorView") as! SelectCountryViewController
        popCountrySelectorView.languageIndex = self.languageIndex
        self.addChildViewController(popCountrySelectorView)
        popCountrySelectorView.view.frame = self.view.frame
        self.view.addSubview(popCountrySelectorView.view)
        popCountrySelectorView.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "applyCountry" {
            let destinationController = segue.destination as! HomeViewController
            destinationController.regionField.text = selectedCountry
        }
    }
}
