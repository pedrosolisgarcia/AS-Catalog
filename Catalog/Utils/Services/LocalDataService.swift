import Foundation

public class LocalDataService {
  
  public static let shared = LocalDataService()
  
  public func getCountries() -> [Country]? {
    if let localCountries = self.readJSONFile(forName: "countries") {
      do {
        let decodedData = try JSONDecoder().decode([String].self, from: localCountries)
        
        return decodedData.map {
          Country(name: $0, imgName: $0)
        }
      } catch {
        print("decode error")
      }
    }
    return nil
  }
  
  public func getRegions() -> [String]? {
    if let localCountries = self.readJSONFile(forName: "regions") {
      do {
        return try JSONDecoder().decode([String].self, from: localCountries)
      } catch {
        print("decode error")
      }
    }
    return nil
  }
  
  private func readJSONFile(forName name: String) -> Data? {
    do {
      if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
        let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
          return jsonData
        }
    } catch {
      print(error)
    }
    return nil
  }
}
