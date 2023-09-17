//
//  APIConfig.swift
//  Catalog
//
//  Created by Pedro Solís García on 24/06/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

internal enum API {
    internal static let baseURL = "https://api.agnieszkaswiatly.com/v1"

    internal enum Path {
        internal static let shopIds = "/shops/availability"
        internal static let collections = "/collections/latest"
        internal static let customer = "/customers"
    }
}
