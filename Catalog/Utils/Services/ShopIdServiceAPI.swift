import Foundation

public class ShopIdServiceAPI {
  
  public static let shared = ShopIdServiceAPI(service: GetRequest())
  private let request: APIRequest!
  
  private init(service: APIRequest) {
    self.request = service
  }
  
  public func getShopIds(result: @escaping (Result<ShopId, APIServiceError>) -> Void) -> Void {
    self.request.getDecodedJSON(endpoint: .getShopIds, completion: result)
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
