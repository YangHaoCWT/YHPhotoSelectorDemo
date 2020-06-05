//
//  YHPickerViewController.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/19.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos

let CellYHPickerCollection = "YHPickerCollectionCell"
let itemCount:CGFloat = 4
let itemWH = (UIScreen.YH_ScreenWidht() - (itemCount - 1)) / itemCount

protocol YHPickerViewDelegate: NSObjectProtocol {
    func selectVideoPhoto(select:[PHAsset])
}

class YHPickerViewController: UIViewController {

    public var selectIndex = 9

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        return flowLayout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.YH_ScreenWidht(), height: UIScreen.YH_ScreenHeight()), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        collectionView.register(YHPickerCollectionCell.self, forCellWithReuseIdentifier: CellYHPickerCollection)
        return collectionView
    }()

    lazy var barItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem.init(title: Bundle.localizedString(forKey: "Preview"), style: .plain, target: self, action: #selector(touchPreview))
        barItem.isEnabled = false
        return barItem
    }()

    lazy var barItemComplete: UIBarButtonItem = {
        let barItemComplete = UIBarButtonItem.init(title: Bundle.localizedString(forKey: "Complete"), style: .plain, target: self, action: #selector(touchBarItemComplete))
        barItemComplete.isEnabled = false
        return barItemComplete
    }()

    var delegate : YHPickerViewDelegate?

    var fetchResult = PHFetchResult<PHAsset>()

    var selectPhotos = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        setToolBar()

        collectionView.reloadData()

    }

    override func loadView() {
        super.loadView()

        view.addSubview(collectionView)

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

}


// MARK: - ToolBar
extension YHPickerViewController {

    func setToolBar() {

        navigationItem.rightBarButtonItem = barItemComplete

        navigationController?.setToolbarHidden(false, animated: true)

        setToolbarItems([barItem], animated: true)

    }

    func setToolBarStatus() {

        if selectPhotos.count > 0 {

            barItem.isEnabled = true
            barItem.title = Bundle.localizedString(forKey: "Preview") + " (" + "\(selectPhotos.count)" + ")"
            barItemComplete.isEnabled = true

        } else {

            barItem.isEnabled = false
            barItem.title = Bundle.localizedString(forKey: "Preview")
            barItemComplete.isEnabled = false

        }

    }

    @objc func touchPreview() {

        let previewController = YHPreviewController.init()

        previewController.photosSelect = selectPhotos

        previewController.delegate = self

        navigationController?.pushViewController(previewController, animated: true)
    }

    @objc func touchBarItemComplete() {

        guard let delegateSelf = delegate else {
            return
        }

        delegateSelf.selectVideoPhoto(select: selectPhotos)

        navigationController?.popViewController(animated: false)

    }

}

extension YHPickerViewController : YHPreviewDelegate {

    func cancelAndSelect(photosSelect: [PHAsset]) {

        self.selectPhotos = photosSelect

        setToolBarStatus()

        collectionView.reloadData()

    }

    func doneDismiss(selectPhotos: [PHAsset]) {

        guard let delegateSelf = delegate else {
            return
        }

        delegateSelf.selectVideoPhoto(select: selectPhotos)

        navigationController?.popViewController(animated: false)

    }

}

extension YHPickerViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellYHPickerCollection, for: indexPath)

        (cell as! YHPickerCollectionCell).setImgeView(asset: fetchResult[indexPath.item])

        isSelectCell(asset: fetchResult[indexPath.item]) ? hiddenSelectedView(cell: cell as! YHPickerCollectionCell) : showSelectedView(cell: cell as! YHPickerCollectionCell)

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? YHPickerCollectionCell else {
            return
        }

        let asset = fetchResult[indexPath.item]

        if selectPhotos.count >= selectIndex && isSelectCell(asset: asset) {
            AlertControllerTools.show(vc: self)
            return
        }

        isSelectCell(asset: asset) ? showSelectedView(cell: cell) : hiddenSelectedView(cell: cell)

        isSelectCell(asset: asset) ? selectPhotos.append(asset) : selectPhotos.removeAll(where: { $0 == asset })

        setToolBarStatus()

    }

    func isSelectCell(asset:PHAsset) -> Bool {

        if selectPhotos.count <= 0 {
            return true
        }

        for assetNew in selectPhotos {
            if assetNew.localIdentifier == asset.localIdentifier {
                return false
            }
        }

        return true

    }

    func showSelectedView(cell:YHPickerCollectionCell) {
        cell.selectedView.isHidden = false
    }

    func hiddenSelectedView(cell:YHPickerCollectionCell) {
        cell.selectedView.isHidden = true
    }

}


