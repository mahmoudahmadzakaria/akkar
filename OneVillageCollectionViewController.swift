//
//  OneVillageCollectionViewController.swift
//  Akkar
//
//  Created by Mahmoud Zakaria on 14/06/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class OneVillageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var villageLocation: UIButton!
    var dataController: DataController!
    var photoSetID: String!
    var village: Village!
    
    var photoID: String!
    
    
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "village == %@", village)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "photoString", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        print(fetchRequest)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(village)-photos")
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //villageLocation.isHidden = true
        let space: CGFloat = 2.0
        let dimension = (self.view.frame.width - (2 * space))/2.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        FlickerDBClient.sharedInstance().photoString = []
        
        setupFetchedResultsController()
        if fetchedResultsController.fetchedObjects?.count == 0 {
            FlickerDBClient.sharedInstance().downloadManyStringImage (photoSetID: photoSetID) { (success, error) in
                if success! {
                    performUIUpdatesOnMain {
                        for photostring in FlickerDBClient.sharedInstance().photoString {
                            let photo = Photo(context: self.dataController.viewContext)
                            photo.photoString = photostring
                            photo.village = self.village
                            try? self.dataController.viewContext.save()
                            //print(photostring)
                            //print(photo.photoString)
                        }
                        
                        self.setupFetchedResultsController()
                        self.collectionView.reloadData()
                    }
                }
                else {
                    self.callAlert(error: error!)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneVillageCollectionViewCell", for: indexPath) as! OneVillageCollectionViewCell
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        cell.imageView.image =  UIImage(named: "PLACEHOLDER_IMAGE")
        
        if photo.photoData == nil {
            FlickerDBClient.sharedInstance().downloadOneDataImage(photoString: photo.photoString) { (success, data, error) in
                if success! {
                    performUIUpdatesOnMain {
                        cell.imageView.image = UIImage(data: data!)
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        
                        // save the image data
                        photo.photoData = data
                        try? self.dataController.viewContext.save()
                    }
                }
            }
        }
        else {
            if let data = photo.photoData {
                cell.imageView.image = UIImage(data: data)

                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            }
        }
        
       
        return cell
    }
    
    @IBAction func openMaps() {
        
        FlickerDBClient.sharedInstance().getLocation(photoID: photoID) { (success, latitude, longitude, error) in
            if success! {
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.openInMaps(launchOptions: nil)
            }
            else {
                self.callAlert(error: error!)
            }
        }
    }
    
    func callAlert(error: String) {
        let alertController = UIAlertController(title: "Alert!", message: error, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
}
