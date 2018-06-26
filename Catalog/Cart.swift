import Foundation

struct Customer: Codable {
    let shopId: String
    let name: String
    let surname: String
    let region: String
    let dateOfWedding: String
    var dressesNames: String
    
    init(shopId: String, name: String, surname: String, region: String, dateOfWedding: String, dressesNames: String){
        self.shopId = shopId
        self.name = name
        self.surname = surname
        self.region = region
        self.dateOfWedding = dateOfWedding
        self.dressesNames = dressesNames
    }
}
