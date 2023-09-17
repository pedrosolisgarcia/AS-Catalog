//
//  APIRequest.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import Foundation

protocol APIRequest {
    func getDecodedJSON<T: Decodable>(endpoint: ServiceEndpoints, completion: @escaping (Result<T, APIServiceError>) -> Void)
    func getData(from url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void)
}
