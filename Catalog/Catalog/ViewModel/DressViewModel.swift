import UIKit

struct DressViewModel {
  let name: String
  let image: UIImage
  
  init(dress: Dress) {
    name = dress.name
    image = dress.image
  }
}
