//
//  DataController.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 07/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import CoreData


class DataController {
    
    static let shared = DataController(withModelName: "TVMaze")
    
    let container:NSPersistentContainer
    var context:NSManagedObjectContext {
        return container.viewContext
    }
    
    private init(withModelName name: String){
        container = NSPersistentContainer(name: name)
    }
    
    func load(completion: (()->())?=nil) {
        container.loadPersistentStores { _,error in
            guard error==nil else { fatalError("Could not load CoreData model. \(error!.localizedDescription)") }
            
            completion?()
        }
    }
    
    
}
