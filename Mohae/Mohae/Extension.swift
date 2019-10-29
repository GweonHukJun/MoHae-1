//
//  Extension.swift
//  Mohae
//
//  Created by 권혁준 on 2019/10/22.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import GooglePlaces

let imageCache = NSCache<AnyObject, AnyObject>()
let noImage = #imageLiteral(resourceName: "icons8-error")

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
         let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: urlString, placeFields: fields, sessionToken: nil, callback: {
                       (place: GMSPlace?, error: Error?) in
                       if let error = error {
                         print("An error occurred: \(error.localizedDescription)")
                         return
                       }
                       if let place = place {
                        // Get the metadata for the first photo in the place photo metadata list.
                           if place.photos?[0] != nil {
                               let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]

                             // Call loadPlacePhoto to display the bitmap and attribution.
                            GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                               if let error = error {
                                 // TODO: Handle the error.
                                 print("Error loading photo metadata: \(error.localizedDescription)")
                                self.image = noImage
                                return
                               } else {
                                 // Display the first image and its attributions.
                                DispatchQueue.main.async {
                                    if let downloadedIamge = UIImage?(photo!) {
                                        imageCache.setObject(downloadedIamge, forKey: urlString as AnyObject)
                                        self.image = downloadedIamge
                                    }
                                }
                                 //self.lblText.attributedText = photoMetadata.attributions;
                               }
                           })
                         } else {
                   
                         }
                   }}
               )
       
    }
}
