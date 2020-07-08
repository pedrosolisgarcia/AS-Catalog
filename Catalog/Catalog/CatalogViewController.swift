import UIKit

class CatalogViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var catalogView: UIBarButtonItem!
  @IBOutlet weak var carouselView: UIBarButtonItem!
  @IBOutlet weak var selectButton: UIButton!
  
  var clientData: Client!
  var region = String()
  var collection: Collection!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    navigationItem.title = "catalog.title".localized().uppercased()

    selectButton.setTitle("catalog.button".localized().uppercased(), for: .normal)
    selectButton.isEnabled = false
    selectButton.alpha = 0.25

    collectionView?.allowsMultipleSelection = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  func didPressZoomButton(_ sender: UIButton) {
    if let indexPath = getCurrentCellIndexPath(sender) {
      
      let zoomImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ImageViewController
      zoomImageView.dress = collection.dresses[indexPath.row].imageData
      self.addChild(zoomImageView)
      zoomImageView.view.frame = self.view.frame
      self.view.addSubview(zoomImageView.view)
      zoomImageView.didMove(toParent: self)
    }
  }
  
  func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
    let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)
    if let indexPath: IndexPath = collectionView.indexPathForItem(at: buttonPosition) {
      return indexPath
    }
    return nil
  }
  
  @IBAction func viewButtonPressed(_ sender: UIBarButtonItem) {
    
    let catalogSize = CGSize(width: 246, height: 416)
    let carouselSize = CGSize(width: 515, height: 850)
    let catalogInset = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
    let carouselInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 40)
    
    let layout = UICollectionViewFlowLayout()

    layout.scrollDirection = .horizontal
    layout.itemSize = sender == catalogView ? catalogSize : carouselSize
    layout.sectionInset = sender == catalogView ? catalogInset : carouselInset
    layout.minimumLineSpacing = sender == catalogView ? 8.0 : 40.0
    layout.minimumInteritemSpacing = sender == catalogView ? 8.0 : 30.0
    
    collectionView.setCollectionViewLayout(layout, animated: true)
    catalogView.image = UIImage(named: sender == catalogView ? "mosaic_sel" : "mosaic")
    carouselView.image = UIImage(named: sender == catalogView ? "carousel" : "carousel_sel")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "selectDresses"{
      
      if let indexPath = collectionView.indexPathsForSelectedItems {
        let destinationController = segue.destination as! SelectionViewController

        var dressesNames = [String]()
        
        for index in indexPath {
          destinationController.selectedDresses.append(collection.dresses[index.row])
          dressesNames.append(collection.dresses[index.row].name)
        }
        clientData.dressesNames = (dressesNames as NSArray).componentsJoined(by: ",")
        destinationController.clientData = clientData
        destinationController.region = region
      }
    }
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate, CatalogCollectionViewCellDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collection.dresses.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatalogCollectionViewCell
    cell.cellDelegate = self
    
    let dress = collection.dresses[indexPath.row]

    cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 22)
    cell.dressLabel.text = dress.name
    cell.dressImageView.image = UIImage(data: dress.imageData!)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collection.dresses[indexPath.row].isSelected = true
    selectButton.isEnabled = true
    selectButton.alpha = 1
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    collection.dresses[indexPath.row].isSelected = false
    if let indexPath = collectionView.indexPathsForSelectedItems {
      if indexPath.count <= 0 {
        selectButton.isEnabled = false
        selectButton.alpha = 0.25
      }
    }
  }
}
