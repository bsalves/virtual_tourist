//
//  CollectionViewController+Collection.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 09/04/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import UIKit

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = self.photos else { return 0 }
        return photos.photos.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        downloadStack.enter()
        guard let photos = self.photos else {
            downloadStack.leave()
            return UICollectionViewCell()
        }
        
        let item = photos.photos.photo[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        if let photoDataPersisted = item.photo {
            cell.activityIndicator.stopAnimating()
            cell.imageView.image = UIImage(data: photoDataPersisted)
            downloadStack.leave()
        } else {
            remote.fetchFlickrImage(with: item, success: { [weak self] (imageData) in
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.imageView.image = UIImage(data: imageData)
                    self?.local.persistImage(item, imageData: imageData)
                    self?.downloadStack.leave()
                }
            }) { [weak self] in
                // fail
                self?.downloadStack.leave()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = self.photos else { return }
        
        local.delete(photo: photos.photos.photo[indexPath.row], deleted: {
            self.photos?.photos.photo.remove(at: indexPath.row)
            collectionView.reloadData()
        }) {
            //failed
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 1
        return CGSize(width: width, height: width)
    }
}
