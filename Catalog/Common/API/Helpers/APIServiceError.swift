//
//  APIServiceError.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
