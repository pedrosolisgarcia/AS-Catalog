import Foundation

struct Client: Codable {
  let appVersion: String
  let dateOfVisit: String
  let shopId: String
  let name: String
  let surname: String
  var region: String
  let dateOfWedding: String
  var dressesNames: String
  var collectionId: Int
  
  init(appVersion: String, dateOfVisit: String, shopId: String, name: String, surname: String, region: String, dateOfWedding: String, dressesNames: String, collectionId: Int) {
    self.appVersion = appVersion
    self.dateOfVisit = dateOfVisit
    self.shopId = shopId
    self.name = name
    self.surname = surname
    self.region = region
    self.dateOfWedding = dateOfWedding
    self.dressesNames = dressesNames
    self.collectionId = collectionId
  }
}
