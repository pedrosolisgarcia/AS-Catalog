import Foundation

public class CostumerService {
  
  class func sendCostumerToAPI(customer: Customer, completion:((Data?, URLResponse?, Error?) -> Void)?) {
    
    var urlComponents = URLComponents()
    
    urlComponents.scheme = "https"
    urlComponents.host = "8e08w9h4m5.execute-api.eu-west-1.amazonaws.com"
    urlComponents.path = "/production/customers"
    guard let url = urlComponents.url else {
      fatalError("Could not create URL from components")
    }
    
    // Specify this request as being a POST method
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Make sure that we include headers specifying that our request's HTTP body
    // will be JSON encoded
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    // Now let's encode out Post struct into JSON data...
    let encoder = JSONEncoder()
    do {
      let jsonData = try encoder.encode(customer)
      // ... and set our request's HTTP body
      request.httpBody = jsonData
      print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
      completion?(nil, nil, error)
    }
    
    // Create and run a URLSession data task with our JSON encoded POST request
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
      
      // APIs usually respond with the data you just sent in your POST request
      if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
        print("SUCCESSFUL: ", utf8Representation)
      } else {
        print("no readable data received in response")
      }
    }
    task.resume()
  }
}
