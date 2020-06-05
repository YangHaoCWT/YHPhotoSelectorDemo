//
//  YHPickerCollectionCell.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/19.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos

class YHPickerCollectionCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageViewPhoto)

        contentView.addSubview(selectedView)

        contentView.addSubview(shadowView)

        contentView.addSubview(labelTime)

    }

    lazy var playImageView: UIImageView = {
        
        guard let image = Bundle.pathImage(pngName: video_playName) else {
            return UIImageView.init()
        }
        
        let imgsize = image.size
        let playImageView = UIImageView.init(frame: CGRect.init(x: (contentView.frame.size.width - imgsize.width) / 2, y: (contentView.frame.size.height - imgsize.height) / 2, width: imgsize.width, height: imgsize.height))
        playImageView.image = image
        playImageView.isHidden = true
        return playImageView
    }()

    lazy var labelTime: UILabel = {
        let labelTime = UILabel.init(frame: CGRect.init(x: 0, y: shadowView.frame.minY, width: frame.size.width - 5, height: 20))
        labelTime.isHidden = true
        labelTime.textColor = UIColor.white
        labelTime.textAlignment = .right
        labelTime.font = UIFont.systemFont(ofSize: 13)
        return labelTime
    }()

    lazy var shadowView: UIView = {
        let shadowView = UIView.init(frame: CGRect.init(x: 0, y: frame.size.height - 20, width: frame.size.height, height: 20))
        shadowView.isHidden = true
        shadowView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return shadowView
    }()

    lazy var selectedView: SelectedView = {
        let selectedView = SelectedView.init(frame: contentView.frame)
        selectedView.isHidden = true
        return selectedView
    }()

    lazy var imageViewPhoto: UIImageView = {
        let imageViewPhoto = UIImageView.init(frame: contentView.frame)
        imageViewPhoto.contentMode = .scaleAspectFill
        imageViewPhoto.clipsToBounds = true
        return imageViewPhoto
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension YHPickerCollectionCell {

    func setImgeView(asset:PHAsset?) {

        guard let phAsset = asset else {
            return
        }

        setupVideo(asset:phAsset)

        /// Waiting Optimize...
        PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize.init(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (image, info) in

            guard let infoDictionary = info else {
                return
            }

            ///  || (infoDictionary[PHImageResultIsDegradedKey] != nil)
            if (infoDictionary[PHImageCancelledKey] != nil) || (infoDictionary[PHImageErrorKey] != nil) {
                return
            }

            DispatchQueue.main.async {
                self.imageViewPhoto.image = image
            }

        }

    }

    func setupVideo(asset:PHAsset) {

        labelTime.isHidden = asset.mediaType == .video ? false : true
        shadowView.isHidden = asset.mediaType == .video ? false : true

        labelTime.text = timeFromDurationSecond(duration: Int(asset.duration))

    }

    func timeFromDurationSecond(duration:Int) -> String {

        var backTime = ""

        if duration < 10 {

            backTime = "0:0" + "\(duration)"

        } else if duration < 60 {

            backTime = "0:" + "\(duration)"

        } else {

            let min = duration / 60
            let sec = duration - min * 60

            if sec < 10 {

                backTime = "\(min)" + ":0" + "\(sec)"

            } else {

                backTime = "\(min)" + ":" + "\(sec)"

            }

        }

        return backTime
    }

}

class SelectedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white.withAlphaComponent(0.3)

        addSubview(selectedButton)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var selectedButton: UIButton = {
        let selectImageWH = frame.size.width / 4
        let selectedButton = UIButton.init(frame: CGRect.init(x: frame.size.width - 5 - selectImageWH, y: frame.size.width - 5 - selectImageWH, width: selectImageWH, height: selectImageWH))
        
        guard let image = Bundle.pathImage(pngName: photoSelectedName) else {
            return UIButton.init()
        }
        selectedButton.setImage(image, for: .normal)
        
        return selectedButton
    }()

}
