//
//  FlickerDBConvenience.swift
//  Akkar
//
//  Created by Mahmoud Zakaria on 12/06/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import Foundation

extension FlickerDBClient {
    
    func getVillages (completionHandlerForgetPhotos: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod_getList,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.UserID: Constants.FlickrParameterValues.UserID,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let mutableMethod: String = ""
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String:AnyObject], method: mutableMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForgetPhotos(false, "Error")
            } else {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = results![Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    completionHandlerForgetPhotos(false, "Error")
                    return
                }
                
                /* GUARD: Is the "photosets" key in our result? */
                guard let photoSets = results![Constants.FlickrResponseKeys.PhotoSets] as? [String:AnyObject] else {
                    completionHandlerForgetPhotos(false , "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in photosSets? */
                guard let photoSet = photoSets[Constants.FlickrResponseKeys.PhotoSet] as? [[String: AnyObject]] else {
                    completionHandlerForgetPhotos(false, "Error")
                    return
                }
                
                self.photoSetID = []
                self.photoSetTitle = []
                for album in photoSet {
                    self.photoSetID.append(album[Constants.FlickrResponseKeys.PhotoSetID] as! String)
                    if let title = album [Constants.FlickrResponseKeys.PhotoSetTitle] as? [String: AnyObject]
                    {
                        if let content = title [Constants.FlickrResponseKeys.PhotoSetContent] as? String {
                            self.photoSetTitle.append(content)
                        }
                    }
                }
                completionHandlerForgetPhotos(true, nil)
            }
        }
    }
    
    func getImageID (photoSetID: String?, completionHandlerForDownloadOneStringImage: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod_getPhotos,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.UserID: Constants.FlickrParameterValues.UserID,
            Constants.FlickrParameterKeys.PhotoSetID: photoSetID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let mutableMethod: String = ""
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String:AnyObject], method: mutableMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDownloadOneStringImage(false, "Error")
            } else {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = results![Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    completionHandlerForDownloadOneStringImage(false, "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in our result? */
                guard let photoSet = results![Constants.FlickrResponseKeys.PhotoSet] as? [String:AnyObject] else {
                    completionHandlerForDownloadOneStringImage(false, "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in photo? */
                guard let photos = photoSet[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    completionHandlerForDownloadOneStringImage(false, "Error")
                    return
                }
               
                for photo in photos {
                    self.photoID.append(photo[Constants.FlickrResponseKeys.PhotoID] as! String)
                    completionHandlerForDownloadOneStringImage(true, nil)
                    break
                }
            }
        }
    }
    
    func downloadOneStringImage (photoSetID: String?, completionHandlerForDownloadOneStringImage: @escaping (_ success: Bool?, _ data: Data?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod_getPhotos,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.UserID: Constants.FlickrParameterValues.UserID,
            Constants.FlickrParameterKeys.PhotoSetID: photoSetID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let mutableMethod: String = ""
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String:AnyObject], method: mutableMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
               completionHandlerForDownloadOneStringImage(false, nil, "Error")
            } else {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = results![Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    completionHandlerForDownloadOneStringImage(false, nil, "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in our result? */
                guard let photoSet = results![Constants.FlickrResponseKeys.PhotoSet] as? [String:AnyObject] else {
                    completionHandlerForDownloadOneStringImage(false, nil, "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in photo? */
                guard let photos = photoSet[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    completionHandlerForDownloadOneStringImage(false, nil, "Error")
                    return
                }
                var photoString: String = ""
                //FlickerDBClient.sharedInstance().photoID = []
                for photo in photos {
                    photoString = photo[Constants.FlickrResponseKeys.MediumURL] as! String
                    //FlickerDBClient.sharedInstance().photoID.append(photo[Constants.FlickrResponseKeys.PhotoID] as! String)
                    break
                }
                
                let session = URLSession.shared
                let imgURL = NSURL(string: photoString)
                let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
                
                let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
                    
                    if downloadError != nil {
                         completionHandlerForDownloadOneStringImage(false, data!, "Error")
                    } else {
                        
                        completionHandlerForDownloadOneStringImage(true, data!, nil)
                    }
                }
                task.resume()
            }
        }
    }
    
    func downloadManyStringImage (photoSetID: String?, completionHandlerForDownloadManyStringImage: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod_getPhotos,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.UserID: Constants.FlickrParameterValues.UserID,
            Constants.FlickrParameterKeys.PhotoSetID: photoSetID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let mutableMethod: String = ""
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String:AnyObject], method: mutableMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDownloadManyStringImage(false, "Error")
            } else {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = results![Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    completionHandlerForDownloadManyStringImage(false, "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in our result? */
                guard let photoSet = results![Constants.FlickrResponseKeys.PhotoSet] as? [String:AnyObject] else {
                    completionHandlerForDownloadManyStringImage(false, "Error")
                    return
                }
                
                /* GUARD: Is the "photoset" key in photo? */
                guard let photos = photoSet[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    completionHandlerForDownloadManyStringImage(false, "Error")
                    return
                }
                
                var photoString: String = ""
                for photo in photos {
                    photoString = photo[Constants.FlickrResponseKeys.MediumURL] as! String
                    FlickerDBClient.sharedInstance().photoString.append(photoString)
                }
                
                //FlickerDBClient.sharedInstance().photoSetID = []
                //for photo in photos {
                   // FlickerDBClient.sharedInstance().photoID.append(photo[Constants.FlickrResponseKeys.PhotoID] as! String)
                    //break
               // }
                
                completionHandlerForDownloadManyStringImage(true, nil)
            }
        }
    }
    
    func downloadOneDataImage (photoString: String?, completionHandlerForDownloadOneDataImage: @escaping (_ success: Bool?,_ data: Data?, _ error: String?) -> Void) {
        
        let session = URLSession.shared
        let imgURL = NSURL(string: photoString!)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandlerForDownloadOneDataImage(false, data!, "Error")
            } else {
                
                completionHandlerForDownloadOneDataImage(true, data!, nil)
            }
        }
        task.resume()
    }
    
    func getLocation (photoID: String?, completionHandlerForGetLocation: @escaping (_ success: Bool?, _ latitude: Double, _ longitude: Double, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod_getLocation,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.PhotoID: photoID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let mutableMethod: String = ""
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String:AnyObject], method: mutableMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetLocation(false, 0, 0, "Error")
            } else {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = results![Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    completionHandlerForGetLocation(false, 0, 0, "Error")
                    return
                }
                
                /* GUARD: Is the "photo" key in our result? */
                guard let photo = results![Constants.FlickrResponseKeys.Photo] as? [String:AnyObject] else {
                    completionHandlerForGetLocation(false, 0, 0, "Error")
                    return
                }
                
                /* GUARD: Is the "photo" key in photo? */
                guard let location = photo[Constants.FlickrResponseKeys.Location] as? [String: AnyObject] else {
                    completionHandlerForGetLocation(false, 0, 0, "Error")
                    return
                }
                
                //print(location)
                guard let latitude = location[Constants.FlickrResponseKeys.Latitude] as? String else {
                    completionHandlerForGetLocation(false, 0, 0, "Error")
                    return
                }
                
                
                guard let longitude = location[Constants.FlickrResponseKeys.Longitude] as? String else {
                    
                    completionHandlerForGetLocation(false, 0, 0, "Error")
                    return
                }
                
                //print(longitude)
                completionHandlerForGetLocation(true, Double(latitude)!, Double(longitude)!, nil)
                
               
            }
        }
    }
}
