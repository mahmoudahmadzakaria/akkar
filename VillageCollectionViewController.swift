//
//  VillageCollectionViewController.swift
//  Akkar
//
//  Created by Mahmoud Zakaria on 11/06/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import CoreData

class VillageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Village>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Village> = Village.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "photosettitle", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "villages")
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let space: CGFloat = 2.0
        let dimension = (self.view.frame.width - (2 * space))/2.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        setupFetchedResultsController()
        collectionView.reloadData()
        
        sendRequest()
    }
    
    func sendRequest() {
        FlickerDBClient.sharedInstance().photoSetID = []
        FlickerDBClient.sharedInstance().photoSetTitle = []
        FlickerDBClient.sharedInstance().photoID = []
        //setupFetchedResultsController()
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            FlickerDBClient.sharedInstance().getVillages() { (success, error) in
                if success! {
                    var indice = 0
                    for photosetid in FlickerDBClient.sharedInstance().photoSetID {
                        let village = Village(context: self.dataController.viewContext)
                        FlickerDBClient.sharedInstance().getImageID (photoSetID: photosetid) { (success, error) in
                            if success! {
                                village.photosetid = photosetid
                                village.photosettitle = FlickerDBClient.sharedInstance().photoSetTitle [indice]
                                village.photoid = FlickerDBClient.sharedInstance().photoID [indice]
                                try? self.dataController.viewContext.save()
                                indice = indice + 1
                            }
                            else {
                               self.callAlert(error: error!)
                            }
                        }
                    }
                    performUIUpdatesOnMain {
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
    
    func callAlert(error: String) {
        let alertController = UIAlertController(title: "Alert!", message: error, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let village = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VillageCollectionViewCell", for: indexPath) as! VillageCollectionViewCell
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        cell.imageView.image =  UIImage(named: "PLACEHOLDER_IMAGE")
        
        if village.backgroundphoto == nil {
            FlickerDBClient.sharedInstance().downloadOneStringImage(photoSetID: village.photosetid) { (success, data, error) in
                if success! {
                    performUIUpdatesOnMain {
                        cell.imageView.image = UIImage(data: data!)
                        cell.label.text = village.photosettitle
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        
                        // save the image data
                        village.backgroundphoto = data
                        //village.photoid = FlickerDBClient.sharedInstance().photoID [indexPath[1]]
                        try? self.dataController.viewContext.save()
                    }
                }
            }
        }
        else {
            if let data = village.backgroundphoto {
                cell.imageView.image = UIImage(data: data)
                cell.label.text = village.photosettitle
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            }
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let village = fetchedResultsController.object(at: indexPath)

        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "OneVillageCollectionViewController") as! OneVillageCollectionViewController
        detailController.photoSetID = village.photosetid
        detailController.village = village
        detailController.dataController = dataController
        if village.backgroundphoto == nil {
            detailController.photoID = FlickerDBClient.sharedInstance().photoID[indexPath[1]]
        }
        else {
            detailController.photoID = village.photoid
        }
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func refresh() {
        setupFetchedResultsController()
        if fetchedResultsController.fetchedObjects?.count != 0 {
            var indice = (fetchedResultsController.fetchedObjects?.count)! - 1
            while indice != -1 {
                let villageToDelete = fetchedResultsController.object(at: [0, indice])
                dataController.viewContext.delete(villageToDelete)
                try? dataController.viewContext.save()
                indice = indice - 1
            }
            
            performUIUpdatesOnMain {
                self.setupFetchedResultsController()
                self.collectionView.reloadData()
                self.sendRequest()
            }
        }
    }
}
