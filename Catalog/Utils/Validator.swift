import Foundation

class Validator {
  
  static func validate(name: String, surname: String, region: String, weddingDate: String) -> Bool {
    return validateCustomerName(name: name)
      && validateCustomerName(name: surname)
      && validateField(field: region)
      && validateField(field: weddingDate)
  }
  
  static func validateField(field: String) -> Bool {
    return field != ""
  }
  
  static func validateCustomerName(name: String) -> Bool {
    let RegEx: String = "\\A\\w{0,25}(\\s+\\w{0,25})?"
    let Test = NSPredicate(format: "SELF MATCHES %@", RegEx)
    return Test.evaluate(with:name)
  }
}
