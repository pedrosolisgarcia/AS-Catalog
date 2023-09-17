//
//  ClientMapper.swift
//  Catalog
//
//  Created by Pedro Solís García on 06/26/18.
//  Copyright © 2018 VILHON Technologies. All rights reserved.
//

import Foundation

class ClientMapper {
    
    static func mapClientMOToClient(clientMO: ClientMO) -> Client {
        return Client(
            appVersion: clientMO.appVersion!,
            dateOfVisit: clientMO.dateOfVisit!,
            shopId: clientMO.shopId!,
            name: clientMO.name!,
            surname: clientMO.surname!,
            region: clientMO.region!,
            dateOfWedding: clientMO.dateOfWedding!,
            dressesNames: clientMO.dressesNames!,
            collectionId: Int(clientMO.collectionId)
        )
    }
}
