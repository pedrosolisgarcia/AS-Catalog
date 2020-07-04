import Foundation

public struct Country: Codable {
  var name: String = ""
  var imgName: String = ""
  
  init(name: String, imgName: String){
    self.name = name
    self.imgName = imgName
  }
}
