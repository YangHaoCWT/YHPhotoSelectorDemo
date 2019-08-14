//
//  PermissionRequest.swift
//  YHSeriesDemo
//
//  Created by 杨浩 on 2019/8/13.
//  Copyright © 2019 杨浩. All rights reserved.
//

import Foundation
import Photos

class YHPermissionRequest {
    
    /// 相册权限
    class func whetherAccessTheAlbum(presentVC:UIViewController, isAccess:@escaping (Bool)->()) {
        
        switch PHPhotoLibrary.authorizationStatus() {
            
        /// User has authorized this application to access photos data
        /// 用户已授权此应用程序访问照片数据
        case .authorized:
            isAccess(true)
            
        /// User has explicitly denied this application access to photos data
        /// 用户已明确拒绝此应用程序访问照片数据
        case .denied:
            setTingAllowAccess(presentVC:presentVC, isAccess: isAccess)
            
        /// User has not yet made a choice with regards to this application
        /// 用户尚未对该应用程序做出选择
        case .notDetermined:
            showAllowAccess(isAccess: isAccess)
            
        /// This application is not authorized to access photo data
        /// 此应用程序无权访问照片数据
        case .restricted:
            setTingAllowAccess(presentVC:presentVC, isAccess: isAccess)
            
        default:
            break
            
        }
        
    }
    
    /// User has not yet made a choice with regards to this application
    /// 用户尚未对该应用程序做出选择
    /// 弹出提示框允许访问
    class func showAllowAccess(isAccess:@escaping (Bool)->()) {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status == .authorized {
                /// 同意访问
                isAccess(true)
            } else if status == .denied || status == .restricted{
                /// 拒绝访问
                isAccess(false)
            }
        })
    }
    
    /// User has explicitly denied this application access to photos data
    /// 用户已明确拒绝此应用程序访问照片数据
    /// This application is not authorized to access photo data
    /// 此应用程序无权访问照片数据
    /// 弹出允许访问相册的设置框
    class func setTingAllowAccess(presentVC:UIViewController, isAccess:@escaping (Bool)->()) {

        let alert = UIAlertController.init(title:Bundle.localizedString(forKey: "Limited access to album"), message: Bundle.localizedString(forKey: "Click Settings to allow access to your album"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: Bundle.localizedString(forKey: "Cancel"), style: .default, handler: { (action) in
            isAccess(false)
        }))

        alert.addAction(UIAlertAction.init(title: Bundle.localizedString(forKey: "Setting"), style: .default, handler: { (action) in
            let url = URL(string: UIApplication.openSettingsURLString)
            if let url = url, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))

        presentVC.present(alert, animated: true) {

        }
        
        
    }

}
