import Foundation

class CustomerMapper {
  
  static func mapCustomerMOToCustomer(customerMO: CustomerMO) -> Customer {
    return Customer(
      appVersion: customerMO.appVersion!,
      dateOfVisit: customerMO.dateOfVisit!,
      shopId: customerMO.shopId!,
      name: customerMO.name!,
      surname: customerMO.surname!,
      region: customerMO.region!,
      dateOfWedding: customerMO.dateOfWedding!,
      dressesNames: customerMO.dressesNames!,
      collectionId: Int(customerMO.collectionId)
    )
  }
}
