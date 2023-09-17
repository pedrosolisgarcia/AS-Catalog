//
//  CollectionManager.swift
//  Catalog
//
//  Created by Pedro Solís García on 24/06/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import Foundation

class CollectionMapper {
    
    public static let shared = CollectionMapper()
    
    public func mapResponseToCollection(_ response: CollectionResponse) -> Collection {
        return Collection(
            id: response.id,
            name: response.shortName,
            dresses: self.mapItemsToDresses(response.items)
        )
    }
    
    private func mapItemsToDresses(_ items: [CollectionResponseItem]) -> [CollectionDresses] {
        return items.filter {
            $0.featuredPictureUrl != nil
        }
        .map {
            CollectionDresses(
                name: $0.name,
                imageUrl: $0.featuredPictureUrl!,
                imageData: nil
            )
        }
    }
}
