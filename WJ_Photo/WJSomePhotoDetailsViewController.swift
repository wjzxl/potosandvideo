//
//  WJSomePhotoDetailsViewController.swift
//  hangge_1512
//
//  Created by 王俊 on 2017/12/19.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary


class SuoLuePicObj: UICollectionViewCell {
    var chooseBut:UIButton!
    
    var ShowImageView:UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //初始化各种控件
        ShowImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        ShowImageView.backgroundColor = UIColor.clear
        ShowImageView.clipsToBounds = true
        ShowImageView.contentMode = .scaleAspectFill
        ShowImageView.isUserInteractionEnabled = false
        self.addSubview(ShowImageView)
        
        chooseBut = UIButton.init(frame: CGRect.init(x: frame.size.width-30, y: 0, width: 30, height: 30))
        chooseBut.backgroundColor = UIColor.clear
        chooseBut.imageView?.clipsToBounds = true
        chooseBut.isSelected = false
        chooseBut.setImage(UIImage.init(named: "noSelected"), for: .normal)
        chooseBut.setImage(UIImage.init(named: "yesSelected"), for: .selected)
        chooseBut.imageView?.contentMode = .scaleAspectFit
        self.addSubview(chooseBut)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WJSomePhotoDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var DataALLLibfet:PHFetchResult<AnyObject>!
    
    var maincollectinView:UICollectionView!
    
    var titlename:String!
    
    var picshowSize:CGSize!
    
    var imageManger:PHCachingImageManager!
    
    var dataAllArr:[PHAsset] = []
    
    var haveThechooseIndex:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = titlename
        self.view.backgroundColor = UIColor.white
        
        imageManger = PHCachingImageManager()
        
        let layoutobj = UICollectionViewFlowLayout()
        
        layoutobj.minimumInteritemSpacing = 2
        layoutobj.minimumLineSpacing = 2
        
        
        maincollectinView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64), collectionViewLayout: layoutobj)
        maincollectinView.delegate = self
        maincollectinView.dataSource = self
        maincollectinView.backgroundColor = UIColor.white
        layoutobj.itemSize = CGSize.init(width: (self.view.frame.size.width-10)/4, height: (self.view.frame.size.width-10)/4)
        maincollectinView.register(SuoLuePicObj.self, forCellWithReuseIdentifier: "CELL")
        self.view.addSubview(maincollectinView)
        
        initThedataformThepotos()
    }
    
    func initThedataformThepotos() {
        
        //获取所有的缩略图
        for i in 0..<DataALLLibfet.count {
            let assets = DataALLLibfet[i] as? PHAsset
            dataAllArr.append(assets!)
            haveThechooseIndex.append(0)
        }
        
        maincollectinView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataAllArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? SuoLuePicObj
        
        cell?.backgroundColor = UIColor.clear
        
        let assObj = dataAllArr[indexPath.row]
        cell?.ShowImageView.backgroundColor = UIColor.clear
        imageManger.requestImage(for: assObj, targetSize: CGSize.init(width: (self.view.frame.size.width-10)/4, height: (self.view.frame.size.width-10)/4), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, inofe) in
            cell?.ShowImageView.image = image
        }
        cell?.chooseBut.tag = 100+indexPath.row
        cell?.chooseBut.addTarget(self, action: #selector(chooseThepiccilik(sender: )), for: .touchUpInside)
        let chooseded = haveThechooseIndex[indexPath.row]
        if chooseded == 0 {
            cell?.chooseBut.isSelected = false
           
        }
        else{
            cell?.chooseBut.isSelected = true
           
        }
        
        return cell!
    }
    
    func chooseThepiccilik(sender:UIButton) {
        let indescd = sender.tag - 100
        let chooseded = haveThechooseIndex[indescd]
        if chooseded == 0 {
            sender.isSelected = true
            haveThechooseIndex[indescd] = 1
        }
        else{
            sender.isSelected = false
            haveThechooseIndex[indescd] = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("the nnumber tag:%d",indexPath.row)
        
        let bigPicView = WJShowTheBigPicViewController()
        bigPicView.curentTheDataWith = indexPath.row + 1
        bigPicView.allDataArr = dataAllArr
        self.navigationController?.pushViewController(bigPicView, animated: true)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (self.view.frame.size.width-25)/4, height: (self.view.frame.size.width-25)/4)
//    }
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(2, 2, 2, 2)
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
