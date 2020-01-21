//
//  ViewController.swift
//  iScan
//
//  Created by zzyong on 2020/1/15.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SwiftyTesseract

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var collectionView: UICollectionView?
    lazy var imageList: NSMutableArray = NSMutableArray.init()
    lazy var swiftyTesseract = SwiftyTesseract(languages: [.english, .chineseSimplified, .chineseTraditional])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageList()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = self.view.bounds
    }
    
    func setupImageList() {

        let image: UIImage! = UIImage.init(named: "id_card")
        let garyImage: UIImage? = ISOpenCVImageProcesser.conver(toGrayImage: image)
        let thresholdImage: UIImage? = ISOpenCVImageProcesser.conver(toThresholdImage: garyImage!)
        
        if let image = image {
            imageList.add(image)
        }
        if let garyImage = garyImage {
            imageList.add(garyImage)
        }
        if let thresholdImage = thresholdImage {
            imageList.add(thresholdImage)
        }
    }
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ISImageViewCell.self, forCellWithReuseIdentifier: "ISImageViewCell")
        self.view.addSubview(collectionView!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell: ISImageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ISImageViewCell", for: indexPath) as! ISImageViewCell
        imageCell.image = self.imageList.object(at: indexPath.item) as? UIImage
        return imageCell
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.frame.size.width
        let cellHeight: CGFloat = cellWidth * 406 / 650
        return CGSize.init(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image: UIImage = self.imageList.object(at: indexPath.item) as! UIImage
        swiftyTesseract.performOCR(on: image) { recognizedString in
          guard let recognizedString = recognizedString else { return }
          print(recognizedString)
        }
    }
}

