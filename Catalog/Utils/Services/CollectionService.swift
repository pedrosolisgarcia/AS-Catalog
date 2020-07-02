import Foundation

public class CollectionServiceAPI {
  
  public static let shared = CollectionServiceAPI()
  
  private init() {}
  private let urlSession = URLSession.shared
  
  public func getLatestCollection(result: @escaping (Result<[CollectionResponse], APIServiceError>) -> Void) {
    getJSONResources(path: API.PATH_COLLECTION.rawValue, completion: result)
  }
  
  public func getImageData(from url: URL, result: @escaping (Result<Data, APIServiceError>) -> Void) {
    getRawResources(from: url, completion: result)
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
  
  private func getRawResources(from url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
    urlSession.dataTask(with: url) { (result) in
      switch result {
        case .success(let (response, data)):
          guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
            completion(.failure(.invalidResponse))
            return
          }
          completion(.success(data))
        case .failure(let error):
          print(error.localizedDescription)
          completion(.failure(.apiError))
      }
    }.resume()
  }
}
