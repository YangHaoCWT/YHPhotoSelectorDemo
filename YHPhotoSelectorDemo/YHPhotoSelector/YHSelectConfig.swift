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
