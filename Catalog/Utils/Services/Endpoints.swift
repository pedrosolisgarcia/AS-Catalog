//
//  Endpoints.swift
//  Catalog
//
//  Created by Pedro Solís García on 17/9/23.
//  Copyright © 2023 Pedro Solís García. All rights reserved.
//

enum ServiceEndpoints {
    case getShopIds
    case getLatestCollection
    case sendClientToAPI(request: Client)

    func getURL() -> String {
        let baseURL = API.baseURL

        switch self {
        case .getShopIds:
            return "\(baseURL)\(API.Path.shopIds)"
        case .getLatestCollection:
            return "\(baseURL)\(API.Path.collections)"
        case .sendClientToAPI:
            return "\(baseURL)\(API.Path.customer)"
        }
    }
}
