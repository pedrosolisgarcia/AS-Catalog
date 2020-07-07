import Foundation

public class CollectionServiceAPI {
  
  public static let shared = CollectionServiceAPI(service: GetRequest())
  private let request: APIRequest!
  
  private init(service: APIRequest) {
    self.request = service
  }
  
  public func getLatestCollection(result: @escaping (Result<[CollectionResponse], APIServiceError>) -> Void) {
    self.request.getDecodedJSON(path: API.PATH_COLLECTION.rawValue, completion: result)
  }
  
  public func getImageData(from url: URL, result: @escaping (Result<Data, APIServiceError>) -> Void) {
    self.request.getData(from: url, completion: result)
  }
}
