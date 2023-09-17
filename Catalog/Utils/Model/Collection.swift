//
//  Collection.swift
//  Catalog
//
//  Created by Pedro Solís García on 24/06/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import Foundation

public struct Collection: Codable {
    public let id: Int
    public let name: String
    public var dresses: [CollectionDresses]
    
    init(id: Int, name: String, dresses: [CollectionDresses]) {
        self.id = id
        self.name = name
        self.dresses = dresses
    }
}

public struct CollectionDresses: Codable {
    public let name: String
    public let imageUrl: String
    public var imageData: Data?
    
    init(name: String, imageUrl: String, imageData: Data?) {
        self.name = name
        self.imageUrl = imageUrl
        self.imageData = imageData
    }
}

public struct CollectionResponse: Decodable {
    public let id: Int
    public let name: String
    public let shortName: String
    public let type: String
    public let featured: Bool
    public let lastUpdateTime: String
    public let items: [CollectionResponseItem]
}

public struct CollectionResponseItem: Decodable {
    public let id: Int
    public let name: String
    public let featuredPictureUrl: String?
    public let type: String
}
