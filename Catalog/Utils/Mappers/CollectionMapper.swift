import Foundation

class CollectionMapper {
  
  static func mapResponseToCollection(_ response: CollectionResponse) -> Collection {
    return Collection(
      id: response.id,
      name: response.shortName,
      dresses: mapItemsToDresses(response.items)
    )
  }
  
  static func mapItemsToDresses(_ items: [CollectionResponseItem]) -> [CollectionDresses] {
    return items.filter {
      $0.featuredPictureUrl != nil
    }
    .map {
      CollectionDresses(
        name: $0.name,
        imageUrl: $0.featuredPictureUrl!,
        imageData: nil,
        isSelected: false
      )
    }
  }
}
