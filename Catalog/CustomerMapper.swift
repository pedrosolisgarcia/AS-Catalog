import Foundation

class CustomerMapper {
    
    static func mapCustomerMOToCustomer(customerMO: CustomerMO) -> Customer {
        return Customer(shopId: "WRO-ID",
                 name: customerMO.name!,
                 surname: customerMO.surname!,
                 region: customerMO.region!,
                 dateOfWedding: customerMO.dateOfWedding!,
                 dressesNames: customerMO.dressesNames!)
    }
}
