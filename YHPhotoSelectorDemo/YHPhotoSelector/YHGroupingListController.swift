//
//  GroupingListController.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/16.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos

let CellGrouping = "CellGrouping"

/// 文件类型 video = 视屏  photo = 照片  all = 视屏+照片
/// File type video = video photo = all = video + photo
public enum selectEnum {
    case video
    case photo
    case all
}

public protocol GroupingListDelegate: NSObjectProtocol {
    func selectVideoPhoto(select:[PHAsset])
}

public class YHGroupingListController: UIViewController {

    /// 可选照片数量 默认最大9张
    /// The default maximum number of photos is 9
    public var selectIndex = 9
    
    /// 默认选择照片
    /// Select photos by default
    public var selectenum : selectEnum = .photo
    
    
    lazy var groupingTabView: UITableView = {
        let groupingTabView = UITableView.init(frame: view.bounds, style: .grouped)
        groupingTabView.backgroundColor = UIColor.white
        groupingTabView.dataSource = self
        groupingTabView.delegate = self
        groupingTabView.register(YHGroupingCell.self, forCellReuseIdentifier: CellGrouping)
        return groupingTabView
    }()

    lazy var groupingTabViewDataSouce: [PHFetchResult<PHAsset>] = {
        let groupingTabViewDataSouce = [PHFetchResult<PHAsset>]()
        return groupingTabViewDataSouce
    }()

    var localizedTitles = [String]()

    public var delegate : GroupingListDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = Bundle.localizedString(forKey: "Custom album select")

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: Bundle.localizedString(forKey: "Cancel"), style: .plain, target: self, action: #selector(dismissController))

        navigationController?.navigationBar.isTranslucent = true

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if localizedTitles.count > 0 {
            return
        }
        
        /// 权限请求
        DispatchQueue.global().async { [weak self] in
            YHPermissionRequest.whetherAccessTheAlbum(presentVC: self!, isAccess: { (isAccess) in
                
                isAccess ? self?.allGroupsTheAlbum() : self?.dismissController()
                
            })
        }
        
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setToolbarHidden(true, animated: true)

    }

    override public func loadView() {
        super.loadView()

        view.addSubview(groupingTabView)

    }

    @objc func dismissController() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true) {}
        }
    }
    
    private func reloadUI() {
        DispatchQueue.main.async {
            self.groupingTabView.reloadData()
        }
    }

}

extension YHGroupingListController: UITableViewDataSource, UITableViewDelegate, YHPickerViewDelegate {

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupingTabViewDataSouce.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: CellGrouping)

        if cell == nil {
            cell = YHGroupingCell.init(style: .default, reuseIdentifier: CellGrouping)
        }

        let asset = groupingTabViewDataSouce[indexPath.row].firstObject
        
        let listName = localizedTitles[indexPath.row] + "   "
        
        let listCount = "(" + "\(groupingTabViewDataSouce[indexPath.row].count)" + ")"

        (cell as! YHGroupingCell).setImgeViewLabelUI(asset: asset, listName: listName, listCount: listCount)

        return cell!
        
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let pickerViewController = YHPickerViewController.init()

        pickerViewController.delegate = self
        
        pickerViewController.selectIndex = selectIndex
        
        pickerViewController.fetchResult = groupingTabViewDataSouce[indexPath.row]
        
        pickerViewController.title = localizedTitles[indexPath.row]

        navigationController?.pushViewController(pickerViewController, animated: true)

    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10 * 2
    }

    func selectVideoPhoto(select: [PHAsset]) {

        guard let delegateSelf = delegate else {
            return
        }

        delegateSelf.selectVideoPhoto(select: select)

        dismissController()

    }

}

extension YHGroupingListController {

    private func inspectionRights() {

        if PHPhotoLibrary.authorizationStatus() != .authorized {

            PHPhotoLibrary.requestAuthorization { [weak self] (status) in

                if PHPhotoLibrary.authorizationStatus() != .authorized {

                    let alert = UIAlertController.init(title: Bundle.localizedString(forKey: "Unable to access album"), message: Bundle.localizedString(forKey: "Please allow to access your album"), preferredStyle: .alert)

                    alert.addAction(UIAlertAction.init(title: Bundle.localizedString(forKey: "Cancel"), style: .default, handler: nil))

                    alert.addAction(UIAlertAction.init(title: Bundle.localizedString(forKey: "Setting"), style: .default, handler: { (action) in


                        UIApplication.shared.open(URL.init(string: "\(UIApplication.openSettingsURLString)")!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: { (bool) in

                        })

                    }))

                    self?.present(alert, animated: true, completion: nil)

                } else {

                    DispatchQueue.main.async { [weak self] in
                        self?.allGroupsTheAlbum()
                    }

                }

            }
        } else {

            allGroupsTheAlbum()

        }

    }

    private func allGroupsTheAlbum() {

        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)

        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumSyncedAlbum, options: nil)

        /// 自定义相册
        /// let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

        let photos = [smartAlbums, syncedAlbums]

        let options = PHFetchOptions.init()

        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]

        /// 图片 || 视屏
        if selectenum == .photo {

            options.predicate = NSPredicate(format: "mediaType == %d",  Int8(PHAssetMediaType.image.rawValue))

        } else if selectenum == .video {

            options.predicate = NSPredicate(format: "mediaType == %d",  Int8(PHAssetMediaType.video.rawValue))

        }

        for fetchResult in photos {

            fetchResult.enumerateObjects { [weak self] (assetCollection, index, stop) in

                ///『空相册』
                if assetCollection.estimatedAssetCount <= 0 { return }

                ///『隐藏照片和视频的文件夹』
                if assetCollection.assetCollectionSubtype == .smartAlbumAllHidden { return }

                //『最近删除』相册
                if assetCollection.assetCollectionSubtype.rawValue == 1000000201 { return }

                let asset = PHAsset.fetchAssets(in: assetCollection, options: options)

                if asset.count > 0 {
                    
                    self?.localizedTitles.append(Bundle.localizedString(forKey: assetCollection.localizedTitle ?? ""))
                    
                    self?.groupingTabViewDataSouce.append(asset)
                }

            }

        }

        reloadUI()
        
    }

}
