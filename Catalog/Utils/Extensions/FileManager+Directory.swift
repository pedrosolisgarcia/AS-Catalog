//
//  FileManager+Directory.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/09/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import Foundation

extension FileManager {
    func getBasePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("DRESS_COLLECTION")
    }
}
