//
//  YHSelectConfig.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/26.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit

let photoNormalName = "YHPhotoSelector.bundle/PhotoNormal.png"
let photoSelectedName = "YHPhotoSelector.bundle/select80.png"
let video_playName = "YHPhotoSelector.bundle/video_play.png"

/// 文件类型 video = 视屏  photo = 照片  all = 视屏+照片
/// File type video = video photo = all = video + photo
public enum selectEnum {
    case video
    case photo
    case all
}

public struct YHSelectConfig {

    /// 可选照片数量 默认最大9张
    /// The default maximum number of photos is 9
    public var selectIndex = 9

    /// 默认选择照片
    /// Select photos by default
    public var selectenum : selectEnum = .photo

}

extension UIScreen {

    class func YH_ScreenWidht() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    class func YH_ScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }

}

class AlertControllerTools: NSObject {

    class func show(vc:UIViewController) {

        let alertVC = UIAlertController.init(title: NSLocalizedString("Maximum number of options", comment: ""), message: "", preferredStyle: .alert)

        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) in

        }))

        vc.present(alertVC, animated: true) {

        }

    }

}
