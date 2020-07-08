import Foundation

protocol APIRequest {
  func getDecodedJSON<T: Decodable>(path: String, completion: @escaping (Result<T, APIServiceError>) -> Void)
  func getData(from url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void)
}
