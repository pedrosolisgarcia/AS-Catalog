//
//  SelectionViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 08/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class SelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var weddingDateLabel: UILabel!
    @IBOutlet weak var dressesLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backHomeScreen: UIBarButtonItem!
    @IBOutlet weak var stackSelection: UIStackView!
    
    var provMonth = [String]()
    var dresses = [DressMO]()
    var selectedDresses = [DressMO]()
    var dressNames = [String]()
    var provCart: Cart!
    weak var client: ClientMO!
    weak var region: RegionMO!
    weak var month: MonthMO!
    var regions = [RegionMO]()
    var months = [MonthMO]()
    var languageIndex: Int!
    
    var fetchRegionsController: NSFetchedResultsController<RegionMO>!
    var fetchMonthsController: NSFetchedResultsController<MonthMO>!
    
    var titleLang: [String] = ["WYBRANE MODELE","SELECTED MODELS","MODELOS SELECCIONADOS"]
    var homeLang: [String] = ["POWRÓT","HOME","INICIO"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var hometownLang: [String] = ["Województwo:","Region:","Región:"]
    var weddingDateLang: [String] = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var confirmLang: [String] = ["POTWIERDŹ WYBÓR","CONFIRM SELECTION","CONFIRMAR SELECCIÓN"]
    var regionNames = ["dolnośląskie", "kujawsko-pomorskie", "lubelskie", "lubuskie", "łódzkie", "małopolskie", "mazowieckie", "opolskie", "podkarpackie", "podlaskie", "pomorskie", "śląskie", "świętokrzyskie", "warmińsko-mazurskie", "wielkopolskie", "zachodniopomorskie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        nameLabel.text = nameLang[languageIndex] + " " + provCart.name
        lastnameLabel.text = lastnameLang[languageIndex] + " " + provCart.lastname
        hometownLabel.text = hometownLang[languageIndex] + " " + provCart.city
        weddingDateLabel.text = weddingDateLang[languageIndex] + " " + provCart.weddingDate
        saveButton.setTitle(confirmLang[languageIndex], for: .normal)
        navigationItem.title = titleLang[languageIndex]
        backHomeScreen.title = homeLang[languageIndex]
        backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        
        let maskPathSave = UIBezierPath(roundedRect: saveButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerSave = CAShapeLayer()
        maskLayerSave.path = maskPathSave.cgPath
        saveButton.layer.mask = maskLayerSave
        
        let maskPathLabel = UIBezierPath(roundedRect: dressesLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerLabel = CAShapeLayer()
        maskLayerLabel.path = maskPathLabel.cgPath
        dressesLabel.layer.mask = maskLayerLabel
        
        fetchRegions()
        fetchMonths()
    }
    
    func fetchRegions() {

        let fetchRegionsRequest: NSFetchRequest<RegionMO> = RegionMO.fetchRequest()
        let sortRegionsDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRegionsRequest.sortDescriptors = [sortRegionsDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchRegionsController = NSFetchedResultsController(fetchRequest: fetchRegionsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchRegionsController.delegate = self
            
            do {
                try fetchRegionsController.performFetch()
                if let fetchedRegions = fetchRegionsController.fetchedObjects {
                    regions = fetchedRegions
                }
            } catch {
                print(error)
            }
        }

        if regions.isEmpty {
            for regionName in regionNames {
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let region = RegionMO(context: appDelegate.persistentContainer.viewContext)
                    region.name = regionName
                    region.count = 0
                    regions.append(region)
                    appDelegate.saveContext()
                }
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
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! SelectionTableViewCell
        let dress = selectedDresses[indexPath.row]

        cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 32)
        cell.dressLabel.text = dress.name
        cell.dressImageView.image = UIImage(named: dress.imgName!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedDressView") as! SelectedDressViewController
        popImageView.dressImage = selectedDresses[indexPath.row].imgName!
        self.addChildViewController(popImageView)
        popImageView.view.frame = self.view.frame
        self.view.addSubview(popImageView.view)
        popImageView.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func clearAllVariables() {
        provCart = nil
        dresses.removeAll()
        selectedDresses.removeAll()
        dressNames.removeAll()
        regions.removeAll()
        tableView = nil
    }
    
    func showCompleteView() {
        
        let popCompleteView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompleteView") as! CompleteViewController
        popCompleteView.languageIndex = self.languageIndex
        self.addChildViewController(popCompleteView)
        popCompleteView.view.frame = self.view.frame
        self.view.addSubview(popCompleteView.view)
        popCompleteView.didMove(toParentViewController: self)
    }
    
    @IBAction func saveSelectionToCart(_ sender: UIButton) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            client = ClientMO(context: appDelegate.persistentContainer.viewContext)
            client.fullName = provCart.name + " " + provCart.lastname
            client.email = provCart.email
            client.phone = provCart.phone
            appDelegate.saveContext()

            if let index = regions.index(where: {$0.name == provCart.city}) {
                regions[index].count += 1
                appDelegate.saveContext()
            } else {
                region = RegionMO(context: appDelegate.persistentContainer.viewContext)
                region.name = provCart.city
                region.count = 1
                appDelegate.saveContext()
            }
            
            if let index = months.index(where: {$0.month == provMonth[1]}) {
                months[index].count += 1
                appDelegate.saveContext()
            } else {
                month = MonthMO(context: appDelegate.persistentContainer.viewContext)
                month.index = Int32(provMonth[0])!
                month.month = provMonth[1]
                month.count = 1
                appDelegate.saveContext()
            }
            
            for dress in dresses {
                if dress.isSelected {
                    dress.count += 1
                    dress.isSelected = false
                    appDelegate.saveContext()
                }
            }
            showCompleteView()
            
            saveButton.isEnabled = false
            saveButton.alpha = 0.25
            navigationItem.backBarButtonItem!.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
            navigationItem.backBarButtonItem!.isEnabled = false
            backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            backHomeScreen.isEnabled = true
        }
    }
    
    @IBAction func backToHomeScreen(_ sender: UIBarButtonItem) {
        clearAllVariables()
        self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
        self.dismiss(animated: false)
    }
}
