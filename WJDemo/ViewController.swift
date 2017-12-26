//
//  ViewController.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController {

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.title = "图片 视频"
        self.view.backgroundColor = UIColor.white
        
        let budhd = UIButton.init(frame: CGRect.init(x: 30, y: 115, width: 80, height: 40))
        budhd.backgroundColor = UIColor.orange
        budhd.setTitle("相册", for: .normal)
        budhd.setTitleColor(UIColor.white, for: .normal)
        budhd.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        budhd.addTarget(self, action: #selector(xiangceciclik), for: .touchUpInside)
        self.view.addSubview(budhd)
        
        let budhd1 = UIButton.init(frame: CGRect.init(x: 130, y: 115, width: 80, height: 40))
        budhd1.backgroundColor = UIColor.orange
        budhd1.setTitle("拍照", for: .normal)
        budhd1.setTitleColor(UIColor.white, for: .normal)
        budhd1.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        budhd1.addTarget(self, action: #selector(paizhaociclik), for: .touchUpInside)
        self.view.addSubview(budhd1)
        
        let budhd2 = UIButton.init(frame: CGRect.init(x: 230, y: 115, width: 80, height: 40))
        budhd2.backgroundColor = UIColor.orange
        budhd2.setTitle("小视频", for: .normal)
        budhd2.setTitleColor(UIColor.white, for: .normal)
        budhd2.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        budhd2.addTarget(self, action: #selector(xiaoshipinciclik), for: .touchUpInside)
        self.view.addSubview(budhd2)
        
    }
    
    func xiangceciclik() {
        let potoslist =  WJALLPhotoListViewController()
        self.navigationController?.pushViewController(potoslist, animated: true)
    }
    
    func paizhaociclik() {
       
    }
    
    func xiaoshipinciclik() {
       
    }
    
    // 相机、麦克风权限
    func isRightCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        return authStatus != .restricted && authStatus != .denied
    }

    // 相册权限
    func isRightPhoto() -> Bool {
        if #available(iOS 9.0, *) {
             let librarystatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
             return librarystatus != .restricted && librarystatus != .denied
        }
        else {
            let authStatus = ALAssetsLibrary.authorizationStatus()
            return authStatus != .restricted && authStatus != .denied
        }
    }
    
    //权限跳转
    func requetSettingForAuth() {
        let url =  NSURL.init(string: UIApplicationOpenSettingsURLString)
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.openURL(url! as URL)
        }
    }
    
    //权限提示框
    func ShowTheTipAuth(tipstr:String,suview:ViewController) {
        let alertVC = UIAlertController(title: tipstr, message: nil, preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            print("click Sure")
        }
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            print("click Cancel")
        }
        alertVC.addAction(acSure)
        alertVC.addAction(acCancel)
        suview.present(alertVC, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

