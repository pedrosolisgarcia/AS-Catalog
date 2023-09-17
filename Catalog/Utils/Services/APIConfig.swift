//
//  APIConfig.swift
//  Catalog
//
//  Created by Pedro Solís García on 17/9/23.
//  Copyright © 2023 Pedro Solís García. All rights reserved.
//

internal enum API {
    internal static let baseURL = "https://api.agnieszkaswiatly.com/v1"

    internal enum Path {
        internal static let shopIds = "/shops/availability"
        internal static let collections = "/collections/latest"
        internal static let customer = "/customers"
    }
}
