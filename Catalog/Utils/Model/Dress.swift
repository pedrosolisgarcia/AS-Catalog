import Foundation

struct Dress {
  var name: [String] = [""]
  var imgName: String = ""
  var isSelected: Bool = false
  
  init(name: [String], imgName: String, isSelected: Bool){
    self.name = name
    self.imgName = imgName
    self.isSelected = isSelected
  }
}
