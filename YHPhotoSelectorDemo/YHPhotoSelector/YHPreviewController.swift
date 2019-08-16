//
//  YHPreviewController.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/22.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AVKit

protocol YHPreviewDelegate: NSObjectProtocol {
    func cancelAndSelect(photosSelect:[PHAsset])
    func doneDismiss(selectPhotos:[PHAsset])
}

let CellYHPreviewCollection = "YHPreviewCollectionCell"

class YHPreviewController: UIViewController {

    lazy var titleView: UILabel = {
        let titleView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: navigationController?.navigationBar.frame.height ?? 0))
        titleView.numberOfLines = 3
        titleView.textAlignment = .center
        titleView.adjustsFontSizeToFitWidth = true
        return titleView
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: UIScreen.YH_ScreenWidht(), height: UIScreen.YH_ScreenHeight())
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(YHPreviewCollectionCell.self, forCellWithReuseIdentifier: CellYHPreviewCollection)
        return collectionView
    }()

    lazy var buttonSelect: UIButton = {
        let selectImageWH = 30
        let buttonSelect = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: selectImageWH, height: selectImageWH))
        buttonSelect.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonSelect.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        guard let image = Bundle.pathImage(pngName: photoSelectedName) else {
            return UIButton.init()
        }
        buttonSelect.setImage(image, for: .normal)
        
        buttonSelect.addTarget(self, action: #selector(clickSelectButton), for: .touchUpInside)
        return buttonSelect
    }()

    var delegate: YHPreviewDelegate?

    var photosSelect = [PHAsset]() {
        didSet {
            operationPhotosSelect = photosSelect
        }
    }

    var operationPhotosSelect = [PHAsset]()
    var itemIndex = 0

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        }

        setNavgationTime(asset: photosSelect.first)

        collectionView.reloadData()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let delegateSelf = delegate else {
            return
        }

        delegateSelf.cancelAndSelect(photosSelect: operationPhotosSelect)

    }

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.white

        view.addSubview(collectionView)

        let itemSelect = UIBarButtonItem.init(customView: buttonSelect)

        let flexibleSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneItem = UIBarButtonItem.init(title: Bundle.localizedString(forKey: "Complete"), style: .done, target: self, action: #selector(clickDoneButton))

        setToolbarItems([itemSelect, flexibleSpace, doneItem], animated: true)

    }

}

extension YHPreviewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosSelect.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellYHPreviewCollection, for: indexPath) as? YHPreviewCollectionCell

        let asset = photosSelect[indexPath.item]

        if isCompare(asset: asset, compareStr: "GIF") {
            cell?.setImgeViewUI(asset: asset)
        }

        cell?.closureHidden = { [weak self] in
            asset.mediaType == .video ? self?.playVideo(asset: asset) : self?.setStatusNavgationToolBar()
        }

        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let lasetIndex = itemIndex

        itemIndex = backIndexItem()

        if lasetIndex != itemIndex {

            setNavgationTime(asset: photosSelect[itemIndex])

            if isSelectCell(asset: photosSelect[itemIndex]) {
                
                guard let image = Bundle.pathImage(pngName: photoNormalName) else {
                    return
                }
                
                buttonSelect.setImage(image, for: .normal)

            } else {

                guard let image = Bundle.pathImage(pngName: photoSelectedName) else {
                    return 
                }
                buttonSelect.setImage(image, for: .normal)

            }

        }
    }



}

extension YHPreviewController {

    func playVideo(asset:PHAsset) {

        PHImageManager.default().requestPlayerItem(forVideo: asset, options: nil) { [weak self] (playerItem, infoDictionary) in

            DispatchQueue.main.async {

                let playerViewController = AVPlayerViewController.init()

                playerViewController.player = AVPlayer.init(playerItem: playerItem)

                self?.present(playerViewController, animated: true, completion: {

                    playerViewController.player?.play()

                })

            }

        }

    }

    func backIndexItem() -> Int {

        let point = view.convert(collectionView.center, to: collectionView)

        let visibleItem = collectionView.indexPathForItem(at: point)

        return visibleItem?.item ?? 0

    }

    func isCompare(asset:PHAsset, compareStr:String) -> Bool {

        let filename = asset.value(forKey: "filename") as? NSString

        let path = filename?.pathExtension

        if compareStr.caseInsensitiveCompare(path ?? "") == .orderedSame {
            return false
        }

        return true

    }

    func setStatusNavgationToolBar() {

        if navigationController?.isNavigationBarHidden == true {

            navigationController?.setNavigationBarHidden(false, animated: false)

            navigationController?.setToolbarHidden(false, animated: false)

            collectionView.backgroundColor = UIColor.white

        } else {

            navigationController?.setNavigationBarHidden(true, animated: false)

            navigationController?.setToolbarHidden(true, animated: false)

            collectionView.backgroundColor = UIColor.black

        }

    }

    func isSelectCell(asset:PHAsset) -> Bool {

        if operationPhotosSelect.count <= 0 {
            return true
        }

        for assetNew in operationPhotosSelect {
            if assetNew.localIdentifier == asset.localIdentifier {
                return false
            }
        }

        return true

    }

    @objc func clickSelectButton() {

        if isSelectCell(asset: photosSelect[itemIndex]) {

            guard let image = Bundle.pathImage(pngName: photoSelectedName) else {
                return
            }
            buttonSelect.setImage(image, for: .normal)

            operationPhotosSelect.append(photosSelect[itemIndex])

        } else {
            
            guard let image = Bundle.pathImage(pngName: photoNormalName) else {
                return
            }
            buttonSelect.setImage(image, for: .normal)

            operationPhotosSelect.removeAll(where: { $0 == photosSelect[itemIndex] })

        }

    }

    @objc func clickDoneButton() {

        guard let delegateSelf = delegate else {
            return
        }

        delegateSelf.doneDismiss(selectPhotos: operationPhotosSelect)

        navigationController?.popViewController(animated: false)

    }

}

extension YHPreviewController {

    func setNavgationTime(asset:PHAsset?) {

        guard let phAsset = asset else {
            return
        }

        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let day = dateFormat.string(from: (phAsset.creationDate ?? nil)!)
        dateFormat.dateFormat = "HH:mm:ss"
        let time = dateFormat.string(from: (phAsset.creationDate ?? nil)!)
        let textAttrString = NSMutableAttributedString.init(string: "\(day)\n\(time)")
        textAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSRange.init(location: 0, length: day.count))
        textAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 11), range: NSRange.init(location:day.count, length: time.count + 1))
        titleView.attributedText = textAttrString

        navigationItem.titleView = titleView

    }

}
