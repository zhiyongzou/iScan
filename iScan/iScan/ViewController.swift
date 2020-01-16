//
//  ViewController.swift
//  iScan
//
//  Created by zzyong on 2020/1/15.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var origlImgView: UIImageView!;
    var garyImgView: UIImageView!;
    var thresholdImgView: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let imageY = 40;
        let imageH = 175;
        let imageW = 125;
        let margin = 10;
        
        
        let image: UIImage! = UIImage.init(named: "image01");
        let garyImage = ISOpenCVImageProcesser.conver(toGrayImage: image);
        let thresholdImage = ISOpenCVImageProcesser.conver(toThresholdImage: garyImage);
        
        origlImgView = UIImageView.init();
        origlImgView.frame = CGRect.init(x: margin, y: imageY, width: imageW, height: imageH);
        origlImgView.image = image;
        self.view.addSubview(origlImgView);
        
        garyImgView = UIImageView.init();
        garyImgView.frame = CGRect.init(x: margin * 2 + imageW, y: imageY, width: imageW, height: imageH);
        garyImgView.image = garyImage;
        self.view.addSubview(garyImgView);
        
        thresholdImgView = UIImageView.init();
        thresholdImgView.frame = CGRect.init(x: margin, y: imageY + imageH + margin, width: imageW, height: imageH);
        thresholdImgView.image = thresholdImage;
        self.view.addSubview(thresholdImgView);
        
    }
}

