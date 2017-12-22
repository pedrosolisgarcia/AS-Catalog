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
    
    var provMonth = [String]()
    //var dresses = [Dress]()
    var dresses = [DressMO]()
    var selectedDresses = [DressMO]()
    var dressNames = [String]()
    var provCart: Cart!
    weak var cart: CartMO!
    weak var client: ClientMO!
    weak var city: CityMO!
    weak var month: MonthMO!
    weak var dressRecord: DressMO!
    //var dressesRecord = [DressMO]()
    var cities = [CityMO]()
    var months = [MonthMO]()
    var clients = [UserTestMO]()
    var languageIndex: Int!
    
    var fetchCitiesController: NSFetchedResultsController<CityMO>!
    //var fetchDressesController: NSFetchedResultsController<DressMO>!
    var fetchMonthsController: NSFetchedResultsController<MonthMO>!
    var fetchClientsController: NSFetchedResultsController<UserTestMO>!
    
    var titleLang: [String] = ["WYBRANE MODELE","SELECTED MODELS","MODELOS SELECCIONADOS"]
    var homeLang: [String] = ["POWRÓT","HOME","INICIO"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var hometownLang: [String] = ["Miasto:","City:","Ciudad:"]
    var weddingDateLang: [String] = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var confirmLang: [String] = ["","CONFIRM SELECTION","CONFIRMAR SELECCIÓN"]
    var confirmationMessageLang: [[String]] = [["To wszystko","Dziękuję, proszę przekazać urządzenie pracownikowi salonu.","Gotowe"],["Ready","Thank you, please give back the device to the person who attended you.","Ok"],["Listo","Gracias, devuelva el dispositivo a la persona que lo atendió.","Vale"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(provCart.name)
        print(provCart.lastname)
        print(provCart.email)
        print(provCart.phone)
        print(provMonth)
        provCart.dresses = dressNames
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        nameLabel.text = nameLang[languageIndex] + " " + provCart.name
        lastnameLabel.text = lastnameLang[languageIndex] + " " + provCart.lastname
        hometownLabel.text = hometownLang[languageIndex] + " " + provCart.city
        weddingDateLabel.text = weddingDateLang[languageIndex] + " " + provCart.weddingDate
        if languageIndex != 0 {
            
            saveButton.setTitle(confirmLang[languageIndex], for: .normal)
        }
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
        
        //CoreData Fetching
        //fetchDresses()
        fetchCities()
        fetchMonths()
        
        for dress in dresses {
            print(dress.imgName! + ": " + String(describing: dress.count))
        }
    }
    
    /*func fetchDresses() {
        print("Starting to fetch dresses...")
        let fetchDressesRequest: NSFetchRequest<DressMO> = DressMO.fetchRequest()
        let sortDressesDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchDressesRequest.sortDescriptors = [sortDressesDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchDressesController = NSFetchedResultsController(fetchRequest: fetchDressesRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchDressesController.delegate = self
            do {
                try fetchDressesController.performFetch()
                if let fetchedDresses = fetchDressesController.fetchedObjects {
                    dressesRecord = fetchedDresses
                    print("Dresses fetched!")
                    for dress in dressesRecord {
                        print(dress.name! + ": " + String(describing: dress.count))
                    }
                    print(dressesRecord.count)
                }
            } catch {
                print(error)
            }
        }
    }*/
    
    func fetchCities() {
        print("Starting to fetch cities...")
        let fetchCitiesRequest: NSFetchRequest<CityMO> = CityMO.fetchRequest()
        let sortCitiesDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchCitiesRequest.sortDescriptors = [sortCitiesDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchCitiesController = NSFetchedResultsController(fetchRequest: fetchCitiesRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchCitiesController.delegate = self
            
            do {
                try fetchCitiesController.performFetch()
                if let fetchedCities = fetchCitiesController.fetchedObjects {
                    cities = fetchedCities
                    print("Cities fetched!")
                    //print(cities[0].name!)
                    print(cities.count)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchMonths() {
        print("Starting to fetch months...")
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
                    print("Months fetched!")
                    print(months[0].month!)
                    print(months.count)
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
        tableView.separatorColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        let dress = dresses[indexPath.row]
        
        // Configure the cell
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
        cart = nil
        provCart = nil
        dresses.removeAll()
        selectedDresses.removeAll()
        dressNames.removeAll()
        cities.removeAll()
        tableView = nil
    }
    
    @IBAction func saveSelectionToCart(_ sender: UIButton) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            client = ClientMO(context: appDelegate.persistentContainer.viewContext)
            client.fullName = provCart.name + " " + provCart.lastname
            client.email = provCart.email
            client.phone = provCart.phone
            appDelegate.saveContext()
            
            if let index = cities.index(where: {$0.name == provCart.city}) {
                cities[index].count += 1
                appDelegate.saveContext()
            } else {
                city = CityMO(context: appDelegate.persistentContainer.viewContext)
                city.name = provCart.city
                city.count = 1
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
            /*for dress in dresses {
             dressRecord = DressMO(context: appDelegate.persistentContainer.viewContext)
             dressRecord.name = dress.name
             dressRecord.count = 0
             dressRecord.isSelected = false
             dressesRecord.append(dressRecord)
             appDelegate.saveContext()
             }*/
            
            for dress in dresses {
                if dress.isSelected {
                    
                    dress.count += 1
                    dress.isSelected = false
                    appDelegate.saveContext()
                }
            }
            
            let alertController = UIAlertController(title: confirmationMessageLang[languageIndex][0], message: confirmationMessageLang[languageIndex][1], preferredStyle: .alert)
            let alertAction = UIAlertAction(title: confirmationMessageLang[languageIndex][2], style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
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
