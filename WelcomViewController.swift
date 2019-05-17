//
//  WelcomeViewController.swift
//  Akkar
//
//  Created by Mahmoud Zakaria on 11/06/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var aboutAkkar: UITextView!
    
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutAkkar.text = Constants.aboutAkkar
    }
    
    @IBAction func discoverAkkar() {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillageCollectionViewController") as! VillageCollectionViewController
        detailController.dataController = dataController
        self.navigationController!.pushViewController(detailController, animated: true)
    }


}

