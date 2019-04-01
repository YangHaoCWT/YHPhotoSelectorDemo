//
//  YHSelectConfig.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/26.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit

let photoNormalName = "PhotoNormal.png"
let photoSelectedName = "select80.png"
let video_playName = "video_play.png"

extension Bundle {
    
    class func pathImage(pngName:String) -> UIImage? {
        
        let bundlePath = Bundle.main.path(forResource: "YHPhotoSelector", ofType: "bundle")
        
        let path = Bundle.init(path: bundlePath ?? "")
        
        let image = UIImage.init(named: pngName, in: path, compatibleWith: nil)
        
        return image

    }
    
    class func localizedString(forKey key: String) -> String {
        return self.localizedStringInit(forKey: key, value: nil)
    }
    
    class func localizedStringInit(forKey key: String, value: String?) -> String {
        
        var language = Locale.preferredLanguages.first!
        
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            language = "zh-Hans"
        } else {
            language = "en"
        }
        
        let bundle = Bundle.init(path: Bundle.main.path(forResource: "YHPhotoSelector", ofType: "bundle") ?? "")
        
        let bundlePath = Bundle.init(path: bundle?.path(forResource: language, ofType: "lproj") ?? "")
        
        
        let v = bundlePath?.localizedString(forKey: key, value: value, table: nil)
        
        return Bundle.main.localizedString(forKey: key, value: v, table: nil)
        
    }
    
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

        let alertVC = UIAlertController.init(title: Bundle.localizedString(forKey: "Maximum number of options"), message: "", preferredStyle: .alert)

        alertVC.addAction(UIAlertAction.init(title: Bundle.localizedString(forKey: "ok"), style: .default, handler: { (action) in

        }))

        vc.present(alertVC, animated: true) {

        }

    }

}
