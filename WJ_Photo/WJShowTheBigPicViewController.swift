//
//  WJShowTheBigPicViewController.swift
//  hangge_1512
//
//  Created by 王俊 on 2017/12/19.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos

class WJShowTheBigPicViewController: UIViewController,UIScrollViewDelegate {

    var mainscrollView:UIScrollView!
    
    var curentTheDataWith:Int!
    
    var allDataArr:[PHAsset] = []
    
    var imageMangerONe:PHCachingImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.title = curentTheDataWith.description + "/" + allDataArr.count.description
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        imageMangerONe = PHCachingImageManager()
        
        mainscrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mainscrollView.delegate = self
        mainscrollView.backgroundColor = UIColor.black
        mainscrollView.showsVerticalScrollIndicator = false
        mainscrollView.showsHorizontalScrollIndicator = false
        mainscrollView.scrollsToTop = false
        mainscrollView.isPagingEnabled = true
        mainscrollView.contentSize = CGSize.init(width: (self.view.frame.size.width * CGFloat(allDataArr.count)), height: self.view.frame.size.height)
        self.view.addSubview(mainscrollView)
        
        initWitTheContentwithData()
        
        if curentTheDataWith != 1 {
           mainscrollView.contentOffset.x = self.view.frame.size.width * CGFloat(curentTheDataWith-1)
        }
        
        
    }
    
    func initWitTheContentwithData() {
        for i in 0..<allDataArr.count {
            
            let phasset = allDataArr[i]
            
           let bigpicview = UIImageView.init(frame: CGRect.init(x: self.view.frame.size.width * CGFloat(i), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            bigpicview.backgroundColor = UIColor.clear
            bigpicview.contentMode = .scaleAspectFit
            bigpicview.isUserInteractionEnabled = false
            
            imageMangerONe.requestImageData(for: phasset, options: nil, resultHandler: { (data, namestr, orientation, infor) in
                let imagsl = UIImage.init(data: data!)
                bigpicview.image = self.wjfixorientationssgs(imahdhad: imagsl!)
            })
            
            mainscrollView.addSubview(bigpicview)
        }
    }
    
    func wjfixorientationssgs(imahdhad:UIImage) -> UIImage {
        if imahdhad.imageOrientation == .up {
            return imahdhad
        }
        
        var transform = CGAffineTransform.identity
        
        switch imahdhad.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: imahdhad.size.width, y: imahdhad.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: imahdhad.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: imahdhad.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch imahdhad.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: imahdhad.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: imahdhad.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(imahdhad.size.width), height: Int(imahdhad.size.height), bitsPerComponent: imahdhad.cgImage!.bitsPerComponent, bytesPerRow: 0, space: imahdhad.cgImage!.colorSpace!, bitmapInfo: imahdhad.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch imahdhad.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(imahdhad.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(imahdhad.size.height), height: CGFloat(imahdhad.size.width)))
            break
            
        default:
            ctx?.draw(imahdhad.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(imahdhad.size.width), height: CGFloat(imahdhad.size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indespage = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
        
         self.title = indespage.description + "/" + allDataArr.count.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
