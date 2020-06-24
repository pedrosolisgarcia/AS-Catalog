import Foundation

public enum APIServiceError: Error {
  case apiError
  case invalidEndpoint
  case invalidResponse
  case noData
  case decodeError
}
