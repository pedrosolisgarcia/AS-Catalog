import Foundation

public class ClientService {
  
  class func sendClientToAPI(client: Client, completion:((Data?, URLResponse?, Error?) -> Void)?) -> Void {
    
    var urlComponents = URLComponents()
    
    urlComponents.scheme = API.SCHEME.rawValue
    urlComponents.host = API.HOST.rawValue
    urlComponents.path = API.PATH_CUSTOMER.rawValue
    guard let url = urlComponents.url else {
      fatalError("Could not create URL from components")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let jsonData = try JSONEncoder().encode(client)
      request.httpBody = jsonData
      print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
      completion?(nil, nil, error)
    }
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) {
      (responseData, response, responseError) in
      guard responseError == nil else {
        completion?(nil, nil, responseError!)
        return
      }
      
      guard (response as! HTTPURLResponse).statusCode == 200 else {
        let status = (response as! HTTPURLResponse).statusCode
        print("HTTP STATUS CODE ERROR:", status)
        completion?(nil, nil, status as? Error)
        return
      }

      if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
        print("SUCCESSFUL: ", utf8Representation)
      } else {
        print("no readable data received in response")
      }
    }
    task.resume()
  }
}
