import Foundation

struct Customer: Codable {
    let appVersion: String
    let dateOfVisit: String
    let shopId: String
    let name: String
    let surname: String
    let region: String
    let dateOfWedding: String
    var dressesNames: String
    
    init(appVersion: String, dateOfVisit: String, shopId: String, name: String, surname: String, region: String, dateOfWedding: String, dressesNames: String){
        self.appVersion = appVersion
        self.dateOfVisit = dateOfVisit
        self.shopId = shopId
        self.name = name
        self.surname = surname
        self.region = region
        self.dateOfWedding = dateOfWedding
        self.dressesNames = dressesNames
    }
}
