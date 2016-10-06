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
    
    var partnerNames: [String] = ["Appvion", "Arcis", "BCC Software", "CMC", "Crawford Technologies", "Dalim", "Domtar", "EMT", "Finch", "Georgia Pacific", "GEP", "Glatfelter", "GMC", "International Paper", "Ironsides", "Lindenmeyr", "Mac Papers", "MBO America", "Midland Paper", "Mitsubishi Imaging", "Mondi", "Muller Martini", "Prinova, Inc.", "Rolland", "Sefas", "Spiral", "Standard", "Tecnau", "Tharsten", "TREKK", "Ultimate", "Verso", "Videk"]
    
    var makerNames: [String] = ["thINK2016-postcards", "thINK2016-postcards2", "thINK2016-postcards3", "thINK2016-postcards4", "thINK2016-postcards5", "thINK2016-postcards6", "thINK2016-postcards7", "thINK2016-postcards8", "thINK2016-postcards9", "thINK2016-postcards10", "thINK2016-postcards11", "thINK2016-postcards12", "thINK2016-postcards13", "thINK2016-postcards14", "thINK2016-postcards15", "thINK2016-postcards16", "thINK2016-postcards17", "thINK2016-postcards18", "thINK2016-postcards19", "thINK2016-postcards20", "thINK2016-postcards21", "thINK2016-postcards22", "thINK2016-postcards23", "thINK2016-postcards24", "thINK2016-postcards25", "thINK2016-postcards26", "thINK2016-postcards27", "thINK2016-postcards28", "thINK2016-postcards29", "thINK2016-postcards37", "thINK2016-postcards30", "thINK2016-postcards31", "thINK2016-postcards32"]
    
    
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
    
    func detectInitialLoad(completion: (_ result: Bool) -> Void) {
        
        // Detect if there is data saved already.
        // If there is not data saved, load it
        if getPartnerByName(name: "TREKK").characters.count > 0 {
            print("Partner user defaults have persisted between usage of app. With name: TREKK")
            completion(true)
        } else {
            print("Partner data needs to be loaded or has been lost")
            
            var index = 0
            
            for name in partnerNames {
                
                if saveNewPartnerObject(name: name, scanned: 0, boothNumber: index,  information: "", makerImage: makerNames[index]) {
                    print("Successfully saved a new partner with the name: \(name) at index: \(index)")
                } else {
                    print("Failed to save a new partner with the name: \(name)")
                }
                print("Index: \(index)")
                index += 1
                if partnerNames.count == index {
                    completion(true)
                    break
                }
            }
        }
    }
    
    //
    //
    //
    func updatePartnerObject(imageTargetName: String) -> Bool {
        
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        let predicate = NSPredicate(format: "%K == %@", "markerImage", imageTargetName)
        let nonNilPredicate = NSPredicate(format: "%K != nil", "name")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, nonNilPredicate])
        partnerFetch.predicate = compoundPredicate
        
        let alphaDescriptor = NSSortDescriptor(key: "name", ascending: true)
        partnerFetch.sortDescriptors = [alphaDescriptor]
        
        do {
            let partnerResult = try self.managedObjectContext.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            
            if partnerResult.count == 0 {
                return false
            } else if partnerResult.count == 1 {
                let partnerObject =  partnerResult[0]
                partnerObject.scanned = 1
                
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
    func getPartnerByName(name: String) -> String {
        
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        let predicate = NSPredicate(format: "%K == %@", "name", name)
        let nonNilPredicate = NSPredicate(format: "%K != nil", "name")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, nonNilPredicate])
        partnerFetch.predicate = compoundPredicate
    
        let alphaDescriptor = NSSortDescriptor(key: "name", ascending: true)
        partnerFetch.sortDescriptors = [alphaDescriptor]
        
        do {
            let partnerResult = try self.managedObjectContext.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            
            if partnerResult.count == 0 {
                return ""
            } else if partnerResult.count == 1 {
                return partnerResult[0].name!
            } else {
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return ""
    }
    
    //
    //
    //
    func getAllPartnerObjects() -> [Partner] {
        
        var returnedNonNilPartners = [Partner]()
        let moc = managedObjectContext
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        let predicate = NSPredicate(format: "%K != nil", "name")
        partnerFetch.predicate = predicate
        
        let alphaDescriptor = NSSortDescriptor(key: "name", ascending: true)
        partnerFetch.sortDescriptors = [alphaDescriptor]
        
        do {
            let returnedPartners = try moc.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            
            for part in returnedPartners {
                if part.name != nil {
                    returnedNonNilPartners.append(part)
                }
            }
            
            return returnedPartners
        } catch {
            fatalError("Failed to fetch Partners: \(error)")
        }
        return returnedNonNilPartners
    }
    
    //
    //
    //
    func getListOfScannedPartners() -> [String] {
        
        var scannedPartners = [String]()
        let partnerFetch = NSFetchRequest<Partner>(entityName: "Partner")
        let predicate = NSPredicate(format: "%K == %d", "scanned", 1)
        let nonNilPredicate = NSPredicate(format: "%K != nil", "name")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, nonNilPredicate])
        partnerFetch.predicate = compoundPredicate
        
        let alphaDescriptor = NSSortDescriptor(key: "name", ascending: true)
        partnerFetch.sortDescriptors = [alphaDescriptor]
        
        do {
            let partnerResult = try self.managedObjectContext.fetch(partnerFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Partner]
            for p in partnerResult {
                scannedPartners.append(p.markerImage!)
            }

        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return scannedPartners
    }
}
