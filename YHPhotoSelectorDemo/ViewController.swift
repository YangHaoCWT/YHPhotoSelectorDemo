//
//  ViewController.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/16.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GroupingListDelegate {

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var navigation: UINavigationController = {
        let yhGroupingListController = YHGroupingListController.init()
        yhGroupingListController.delegate = self
        yhGroupingListController.selectIndex = 5
        yhGroupingListController.selectenum = .photo
        let navigation = UINavigationController.init(rootViewController: yhGroupingListController)
        navigation.modalPresentationStyle = .overFullScreen
        return navigation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationController()
    }

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }

    func setNavigationController() {
        self.title = Bundle.localizedString(forKey: "YHPhotoSelector")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = Bundle.localizedString(forKey: "Custom style")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(navigation, animated: true) {

        }
    }

}

// MARK: - GroupingListDelegate
extension ViewController {
    
    func selectVideoPhoto(select: [PHAsset]) {
        print("已选中的照片==\(select.count)张")
    }
    
}
