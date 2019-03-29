//
//  YHPreviewCollectionCell.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/23.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos

class YHPreviewCollectionCell: UICollectionViewCell {

    var closureHidden:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(scrollView)

        contentView.addSubview(playImageView)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var playImageView: UIImageView = {
        let imgsize = UIImage.init(named: video_playName)!.size
        let playImageView = UIImageView.init(frame: CGRect.init(x: (contentView.frame.size.width - imgsize.width) / 2, y: (contentView.frame.size.height - imgsize.height) / 2, width: imgsize.width, height: imgsize.height))
        playImageView.image = UIImage.init(named: video_playName)
        playImageView.isHidden = true
        return playImageView
    }()

    lazy var zoomImageView: UIImageView = {
        let zoomImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        zoomImageView.contentMode = .scaleAspectFit
        return zoomImageView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: zoomImageView.frame) /// frame
        scrollView.contentSize = zoomImageView.frame.size
        scrollView.addSubview(zoomImageView)
        scrollView.setZoomScale(1, animated: false)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        let tapTouch = UITapGestureRecognizer.init(target: self, action: #selector(touchScrollView(tap:)))
        let tapZoom = UITapGestureRecognizer.init(target: self, action: #selector(touchScrollViewDouble(tap:)))
        tapZoom.numberOfTapsRequired = 2
        tapTouch.require(toFail: tapZoom)
        scrollView.addGestureRecognizer(tapTouch)
        scrollView.addGestureRecognizer(tapZoom)
        scrollView.delegate = self
        return scrollView
    }()

    @objc func touchScrollView(tap:UITapGestureRecognizer) {

        guard let closure = closureHidden else {
            return
        }

        closure()

    }

    @objc func touchScrollViewDouble(tap:UITapGestureRecognizer) {

        if scrollView.zoomScale > 1 {

            scrollView.setZoomScale(1, animated: true)

        } else {

            let point = tap.location(in: zoomImageView)

            let zoomScaleNew = scrollView.maximumZoomScale

            let sizeX = frame.size.width / zoomScaleNew

            let sizeY = frame.size.height / zoomScaleNew

            scrollView.zoom(to: CGRect.init(x: point.x - sizeX / 2, y: point.y - sizeY / 2, width: sizeX, height: sizeY), animated: true)
        }

    }

}

extension YHPreviewCollectionCell {

    func setImgeViewUI(asset:PHAsset?) {

        guard let phAsset = asset else {
            return
        }

        playImageView.isHidden = phAsset.mediaType == .video ? false : true

        let option = PHImageRequestOptions.init()

        option.resizeMode = .fast

        /// Waiting Optimize...
        PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize.init(width: UIScreen.YH_ScreenWidht() * 2, height: UIScreen.YH_ScreenHeight() * 2), contentMode: .aspectFill, options: option) { [weak self] (image, info) in

            guard let infoDictionary = info else {
                return
            }

            ///  || (infoDictionary[PHImageResultIsDegradedKey] != nil)
            if (infoDictionary[PHImageCancelledKey] != nil) || (infoDictionary[PHImageErrorKey] != nil) {
                return
            }

            DispatchQueue.main.async {
                self?.zoomImageView.image = image
            }

        }

    }

}

extension YHPreviewCollectionCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }

}
