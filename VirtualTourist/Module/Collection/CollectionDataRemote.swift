//
//  CollectionDataRemote.swift
//  VirtualTourist
//
//  Created by Bruno Soares Alves on 15/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import Foundation

class CollectionDataRemote {
    
    lazy var localData = CollectionDataLocal()
    
    private var flickrImageStringUrl: String? {
        var dictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path)
            return dictionary?["Flickr_Photo_URL"] as? String
        }
        return nil
    }
    
    private var flickrImagesStringUrl: String? {
        var dictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path)
            return dictionary?["Flickr_Photos_URL"] as? String
        }
        return nil
    }
    
    func fetchFlickrImages(with pin: PinModel, success: @escaping (Data) -> (), fail: @escaping () -> ()) {
        
        if var urlString = self.flickrImagesStringUrl {
            
            urlString = urlString.replacingOccurrences(of: "{lat}", with: String(describing: pin.coordinates.latitude))
            urlString = urlString.replacingOccurrences(of: "{lon}", with: String(describing: pin.coordinates.longitude))
            urlString = urlString.replacingOccurrences(of: "{page}", with: String(describing: arc4random_uniform(99)))
            
            guard let url = URL(string: urlString) else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if error != nil {
                    // fail
                    fail()
                    return
                }
                guard let data = data else {
                    fail()
                    return
                }
                success(data)
            }
            task.resume()
            return
        }
        fail()
    }

    
    func fetchFlickrImage(with photo: FlickrPhotoModel, success: @escaping (Data) -> (), fail: @escaping () -> ()) {
        
        if var urlString = self.flickrImageStringUrl {
            // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_q.jpg
            urlString = urlString.replacingOccurrences(of: "{farm-id}", with: String(describing: photo.farm))
            urlString = urlString.replacingOccurrences(of: "{server-id}", with: photo.server)
            urlString = urlString.replacingOccurrences(of: "{id}", with: photo.id)
            urlString = urlString.replacingOccurrences(of: "{secret}", with: photo.secret)
            guard let url = URL(string: urlString) else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if error != nil {
                    // fail
                    fail()
                    return
                }
                guard let data = data else {
                    fail()
                    return
                }
                success(data)
            }
            task.resume()
            return
        }
        fail()
    }
    
}
