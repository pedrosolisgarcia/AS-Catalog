import Foundation

class GetRequest: APIRequest {
  private let urlSession = URLSession.shared
  
  private let jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return jsonDecoder
  }()

  func getDecodedJSON<T: Decodable>(endpoint: ServiceEndpoints, completion: @escaping (Result<T, APIServiceError>) -> Void) -> Void {
      var urlComponents = URLComponents(string: endpoint.getURL())

      guard let url = urlComponents?.url else {
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
  
  func getData(from url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void) -> Void {
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
