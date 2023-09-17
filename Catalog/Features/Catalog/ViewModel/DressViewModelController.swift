//
//  DressViewModelController.swift
//  Catalog
//
//  Created by Pedro Solís García on 09/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

class DressViewModelController {
    
    fileprivate var viewModels: [DressViewModel?] = []
    fileprivate var collectionId: Int?
    
    public func getDresses() -> Void {
        do {
            let fullPath = FileManager.getBasePath(FileManager.default)()
            
            guard  let data = try? Data(contentsOf: fullPath, options: []) else {
                print("File not found")
                return
            }
            
            let loadedUserData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Data
            let collection = try JSONDecoder().decode(Collection.self, from: loadedUserData)
            let dresses = DressesMapper.mapToDresses(collection.dresses)
            
            self.viewModels = DressViewModelController.initViewModels(dresses)
            self.collectionId = collection.id
        } catch {
            print("Couldn't read file.")
        }
    }
    
    var viewModelsCount: Int {
        return viewModels.count
    }
    
    func getCollectionId() -> Int {
        return self.collectionId!
    }
    
    func viewModel(at index: Int) -> DressViewModel? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        return viewModels[index]
    }
}

private extension DressViewModelController {
    
    static func initViewModels(_ dresses: [Dress?]) -> [DressViewModel?] {
        return dresses.map { dress in
            if let dress = dress {
                return DressViewModel(dress: dress)
            } else {
                return nil
            }
        }
    }
    
}
