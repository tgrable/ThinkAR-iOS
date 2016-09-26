//
//  DownloadMarker.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/21/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit


class DownloadMarker: BaseUIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // The menu delegate
    weak var printDelegate:MarkerProtocol?
    
    // MARK: UIView Methods
    //
    // Declaration of the UIView init method
    // Make sure this view has a tag of 11 on it so it can be removed when needed to by the UIViewController using it
    //
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.tag = 11
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        // Collection view layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 290, height: 220)
        
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.register(MarkerCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.white
        self.addSubview(collectionView!)
        
        
        // UIButtons as collection view items
        let markerOneImage: UIImage = UIImage(named:"Marker1")!
        markerImagewCells.append(markerOneImage)
        
        
        let markerTwoImage: UIImage = UIImage(named:"Marker2")!
        markerImagewCells.append(markerTwoImage)
        
        // UIButtons as collection view items
        let markerThreeImage: UIImage = UIImage(named:"Marker3")!
        markerImagewCells.append(markerThreeImage)
        
    }
    
    //
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Print Function
    //
    //
    //
    func printMarkerImage(markerIndex: Int) {
        
        print("HERE")
        
        let selectedMarkerImage = markerImagewCells[markerIndex]
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "Print Marker"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = selectedMarkerImage
        
        let printCompletionHandler: UIPrintInteractionCompletionHandler = { (controller, success, error) -> Void in
            
            if success {
                // Printed successfully
                // Remove file here ...
                print("Success")
                self.printDelegate!.printJobCallback(flag: 0)
            } else {
                // Printing failed, report error ...
                print("Failed")
                if let err = error {
                    print("Error \(err.localizedDescription)")
                    self.printDelegate!.printJobCallback(flag: 1)
                } else {
                    self.printDelegate!.printJobCallback(flag: 2)
                }
            }
        }
        
        printController.present(from: self.frame, in: self, animated: true, completionHandler: printCompletionHandler)
    }
    
    func printCompletionHandler(interactionController: UIPrintInteractionController, success: Bool, error: NSError) {
        
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    //
    //
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MarkerCell
        
        cell.backgroundImage.image = markerImagewCells[indexPath.row]
        return cell    // Create UICollectionViewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markerImagewCells.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1  // Number of section
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
        // Select operation
        self.printMarkerImage(markerIndex: indexPath.row)
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 290, height: 220) // The size of one cell
    }
}
