//
//  ISImageViewCell.swift
//  iScan
//
//  Created by zzyong on 2020/1/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class ISImageViewCell: UICollectionViewCell {
    
    open var image: UIImage? {
        didSet {
            if let image = self.image as UIImage? {
                imageView?.image = image
            }
        }
    }
    
    private var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        setupSubviews()
    }
    
    override func layoutSubviews() {
        imageView?.frame = self.contentView.bounds
    }
    
    func setupSubviews() {
        imageView = UIImageView.init()
        self.contentView.addSubview(imageView!)
    }
}
