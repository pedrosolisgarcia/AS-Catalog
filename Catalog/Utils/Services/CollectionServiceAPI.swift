//
//  CollectionServiceAPI.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import Foundation

public class CollectionServiceAPI {
    
    public static let shared = CollectionServiceAPI(service: GetRequest())
    private let request: APIRequest!
    
    private init(service: APIRequest) {
        self.request = service
    }
    
    public func getLatestCollection(result: @escaping (Result<[CollectionResponse], APIServiceError>) -> Void) -> Void {
        self.request.getDecodedJSON(endpoint: .getLatestCollection, completion: result)
    }
    
    public func getImageData(from url: URL, result: @escaping (Result<Data, APIServiceError>) -> Void) -> Void {
        self.request.getData(from: url, completion: result)
    }
}
