import Foundation

public class ShopIdServiceAPI {
  
  public static let shared = ShopIdServiceAPI()
  
  private init() {}
  private let urlSession = URLSession.shared
  
  public func getShopIds(result: @escaping (Result<ShopId, APIServiceError>) -> Void) {
    getJSONResources(path: API.PATH_SHOPID.rawValue, completion: result)
  }
  
  private let jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return jsonDecoder
  }()
  
  private func getJSONResources<T: Decodable>(path: String, completion: @escaping (Result<T, APIServiceError>) -> Void) {
    var urlComponents = URLComponents()

    urlComponents.scheme = API.SCHEME.rawValue
    urlComponents.host = API.HOST.rawValue
    urlComponents.path = path
    guard let url = urlComponents.url else {
      completion(.failure(.invalidEndpoint))
      return
    }
   
    urlSession.dataTask(with: url) { (result) in
      switch result {
        case .success(let (response, data)):
          guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
            completion(.failure(.invalidResponse))
            return
          }
          do {
            let values = try self.jsonDecoder.decode(T.self, from: data)
            completion(.success(values))
          } catch let error {
            print(error)
            completion(.failure(.decodeError))
          }
        case .failure(let error):
          print(error.localizedDescription)
          completion(.failure(.apiError))
        }
     }.resume()
  }
  
  public func getShopId() -> String? {
    return UserDefaults.standard.string(forKey: "SHOP-ID")
  }
  
  public func hasRegisteredShopId() -> Bool {
    return self.getShopId() != nil
  }
  
  public func saveShopId(shopId: String) -> String? {
    UserDefaults.standard.setValue(shopId, forKey: "SHOP-ID")
    print("Value changed to " + self.getShopId()!)
    return self.getShopId()
  }
}
