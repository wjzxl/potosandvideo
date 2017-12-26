//
//  WJALLPhotoListViewController.swift
//  hangge_1512
//
//  Created by 王俊 on 2017/12/19.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class PotosObj {
    var title:String!
    
    var fetchResults:PHFetchResult<AnyObject>!
    
    init(title:String,fetchResults:PHFetchResult<AnyObject>) {
        self.title = title
        self.fetchResults = fetchResults
    }
}

class WJALLPhotoListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var allItems:[PotosObj] = []
    
    var maintTaleView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        self.title = "系统相册集"
        
        maintTaleView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height-64), style: .plain)
        maintTaleView.backgroundColor = UIColor.clear
        maintTaleView.delegate = self
        maintTaleView.dataSource = self
        maintTaleView.showsVerticalScrollIndicator = false
        maintTaleView.separatorStyle = .none
        self.view.addSubview(maintTaleView)
        
       // PHPhotoLibrary.shared().register(self as! PHPhotoLibraryChangeObserver)
        
        choosePothos()
        
        // Do any additional setup after loading the view.
    }
    
    func choosePothos() {
        if isRightPhoto() {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    
                    
                   let getalloption = PHFetchOptions()
                   let getalbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: getalloption)
                    
                    self.handeleptohdsn(collection: getalbums as! PHFetchResult<AnyObject>)
                    
                    let otherons = PHCollectionList.fetchTopLevelUserCollections(with: nil)
                    self.handeleptohdsn(collection: otherons as! PHFetchResult<AnyObject>)
                    
                    //相册按包含的照片数量排序（降序）
                    self.allItems.sort { (item1, item2) -> Bool in
                        return item1.fetchResults.count > item2.fetchResults.count
                    }
                    
                    DispatchQueue.main.async(execute: {
                         self.maintTaleView.reloadData()
                    })
                }
            })
        }
        else
        {
            ShowTheTipAuthqqqq(tipstr: "你没有开启相册权限,请先去开启")
        }
    }
    
    private func handeleptohdsn(collection:PHFetchResult<AnyObject>){
        
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            guard let c = collection[i] as? PHAssetCollection else { return }
            let assetsFetchResult = PHAsset.fetchAssets(in: c ,options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
                allItems.append(PotosObj(title: c.localizedTitle!, fetchResults: assetsFetchResult as! PHFetchResult<AnyObject>))
            }
        }
        
    }
    
    
    //权限提示框
    func ShowTheTipAuthqqqq(tipstr:String) {
        let alertVC = UIAlertController(title: tipstr, message: nil, preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            print("click Sure")
        }
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            print("click Cancel")
        }
        alertVC.addAction(acSure)
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let potohitem = allItems[indexPath.row]
        
        let suoLueObjview = WJSomePhotoDetailsViewController()
        suoLueObjview.DataALLLibfet = potohitem.fetchResults
        suoLueObjview.titlename = strchnagetoChesise(namestr: potohitem.title)
        self.navigationController?.pushViewController(suoLueObjview, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sthdhf = "CELL"
        var cell = tableView.dequeueReusableCell(withIdentifier: sthdhf)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: sthdhf)
        }
        
        if ((cell?.contentView.subviews.count) != nil) {
            for viedue in (cell?.contentView.subviews)! {
                viedue.removeFromSuperview()
            }
        }
        
        cell?.accessoryType = .disclosureIndicator
        
        let potohitem = allItems[indexPath.row]
        
        let titlename = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: self.view.frame.size.width-50, height: 20))
        titlename.backgroundColor = UIColor.clear
        titlename.text =  strchnagetoChesise(namestr: potohitem.title)
        titlename.textColor = UIColor.black
        titlename.font = UIFont.systemFont(ofSize: 17)
        cell?.contentView.addSubview(titlename)
        
        let linksdf = UILabel.init(frame: CGRect.init(x: 0, y: 39.5, width: self.view.frame.size.width, height: 0.5))
        linksdf.backgroundColor = UIColor.gray
        cell?.contentView.addSubview(linksdf)
        
        return cell!
    }
    
    func strchnagetoChesise(namestr:String) -> String {
        
        if namestr == "Camera Roll" {
            return "相机胶卷"
        }
        
        if namestr == "Recently Added" {
            return "最近添加"
        }
        
        if namestr == "Favorites" {
            return "个人收藏"
        }
        
        if namestr == "Recently Deleted" {
            return "最近删除"
        }
        
        if namestr == "Selfies" {
            return "自拍"
        }
        
        if namestr == "Slo-mo" {
            return "慢动作"
        }
        
        if namestr == "Screenshots" {
            return "屏幕快照"
        }
        
        
        return namestr
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
