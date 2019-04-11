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
        guard let photos = self.photos else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        DispatchQueue.global().async { [weak self] in
            self?.remote.fetchFlickrImage(with: photos.photos.photo[indexPath.row], success: { (imageData) in
                cell.imageView.image = UIImage(data: imageData)
            }) {
                // fail
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 1
        return CGSize(width: width, height: width)
    }
}
