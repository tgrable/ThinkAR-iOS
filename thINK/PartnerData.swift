//
//  PartnerData.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/26/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit
import CoreData

class PartnerData: NSObject {
    
    // Partner data and UserDefaults
    var managedObjectContext: NSManagedObjectContext
    var partnerNames: [String] = ["APPVION", "ARCIS", "BCC SOFTWARE", "CMC", "CRAWFORD TECHNOLOGIES", "DALIM",
                                  "DOMTAR", "EMT", "FINCH", "GEORGIA PACIFIC", "GEP EHRET", "GLATFELTER",
                                  "GMC", "INTERNATIONAL PAPER", "IRONSIDES", "LINDENMEYR MUNROE", "MAC PAPERS", "MBO AMERICA",
                                  "MIDLAND PAPER", "MITSUBISHI IMAGING", "MONDI", "MULLER MARTINI", "PRINOVA, INC.", "ROLLAND",
                                  "SEFAS", "SPIRAL", "STANDARD", "TECNAU", "THARSTERN", "ULTIMATE",
                                  "VERSO", "VIDEK", "Extra Set #1", "Extra Set #2", "Extra Set #3", "TREKK"]
    var partnerMakers: [String] = ["", "", "", "", "", "",
                                   "", "", "", "", "", "",
                                   "", "", "", "", "", "",
                                   "", "", "", "", "", "",
                                   "", "", "", "", "", "",
                                   "", "", "", "", "", ""]
    
    
    //
    // Constructor to load the partner data if not persisted
    //
    override init() {
    
        
        // Initialize the core data stack before the super.init call
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "thINK", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("thINK.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }

    }
    
    func detectInitialLoad() {
        
        // Detect if there is data saved already.
        // If there is not data saved, load it
        if let p = getPartnerByName(name: "TREKK").name {
            print("Partner user defaults have persisted between usage of app. With name: \(p)")
        } else {
            print("Partner data needs to be loaded or has been lost")
            
            var index = 0
            for name in partnerNames {
                
                if saveNewPartnerObject(name: name, scanned: 0, boothNumber: index,  information: "", makerImage: partnerMakers[index]) {
                    print("Successfully saved a new partner with the name: \(name)")
                } else {
                    print("Failed to save a new partner with the name: \(name)")
                }
                index += 1
            }
        }
    }
    
    
    //
    //
    //
    func updatePartnerObject(p: Partner) -> Bool {
        
        let entity = NSEntityDescription.entity(forEntityName: "Partner", in: managedObjectContext)
        var partnerObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Partner
        
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        let predicate = NSPredicate(format: "%K == %@", "name", p.name!)
        partnerFetch.predicate = predicate
        
        let alphaDescriptor = NSSortDescriptor(key: "name", ascending: true)
        partnerFetch.sortDescriptors = [alphaDescriptor]
        
        do {
            let partnerResult = try self.managedObjectContext.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            print ("Count of partnerResult \(partnerResult.count)")
            
            if partnerResult.count == 0 {
                print ("No objects found")
                return false
            } else if partnerResult.count == 1 {
                print ("One object found")
                partnerObject =  partnerResult[0]
                partnerObject.name = p.name
                partnerObject.scanned = p.scanned
                partnerObject.boothNumber = p.boothNumber
                partnerObject.information = p.information
                partnerObject.markerImage = p.markerImage
                
                do {
                    try partnerObject.managedObjectContext?.save()
                    
                    return true
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            } else {
                print ("More than one object found")
                return false
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return false
    }
    
    //
    //
    //
    func saveNewPartnerObject(name: String, scanned: Int, boothNumber: Int,  information: String, makerImage: String) -> Bool {
        
        let entity = NSEntityDescription.entity(forEntityName: "Partner", in: managedObjectContext)
        let partner = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Partner
        partner.name = name
        partner.scanned = scanned as NSNumber?
        partner.boothNumber = boothNumber as NSNumber?
        partner.information = information
        partner.markerImage = makerImage

        do {
            try partner.managedObjectContext?.save()
            
            return true
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        return false
    }
    
    //
    //
    //
    func getPartnerByName(name: String) -> Partner {
        
        let entity = NSEntityDescription.entity(forEntityName: "Partner", in: managedObjectContext)
        var partnerObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Partner
        
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        let predicate = NSPredicate(format: "%K == %@", "name", name)
        partnerFetch.predicate = predicate
    
        let alphaDescriptor = NSSortDescriptor(key: "name", ascending: true)
        partnerFetch.sortDescriptors = [alphaDescriptor]
        
        do {
            let partnerResult = try self.managedObjectContext.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            print ("Count of partnerResult \(partnerResult.count)")
            
            if partnerResult.count == 0 {
                print ("No objects found")
                return partnerObject
            } else if partnerResult.count == 1 {
                print ("One object found")
                partnerObject =  partnerResult[0]
                return partnerObject
            } else {
                print ("More than one object found")
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return partnerObject
    }
    
    //
    //
    //
    func getAllPartnerObjects() -> [Partner] {
        
        var returnedPartners = [Partner]()
        let moc = managedObjectContext
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        
        do {
            returnedPartners = try moc.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            return returnedPartners
        } catch {
            fatalError("Failed to fetch Partners: \(error)")
        }
        return returnedPartners
    }
}
