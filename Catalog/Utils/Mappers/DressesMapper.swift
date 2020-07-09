import UIKit

class DressesMapper {
  
  static func mapToDresses(_ dresses: [CollectionDresses]) -> [Dress] {
    return dresses.map {
      Dress(
        name: $0.name,
        image: UIImage(data: $0.imageData!)!
      )
    }
  }
}
