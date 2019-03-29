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

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationController()

    }

    override func loadView() {
        super.loadView()

        view.addSubview(tableView)

    }

    func setNavigationController() {

        self.title = NSLocalizedString("YHPhotoSelector", comment: "")

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = NSLocalizedString("Custom style", comment: "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        yh_SelectPhotoVideo()

    }


    public func yh_SelectPhotoVideo() {


        let yhGroupingListController = YHGroupingListController.init()
        yhGroupingListController.delegate = self
        let selectConfig = YHSelectConfig.init(selectIndex: 5, selectenum: .all)
        yhGroupingListController.selectConfig = selectConfig

        present(UINavigationController.init(rootViewController: yhGroupingListController), animated: true) {

        }

    }

    func selectVideoPhoto(select: [PHAsset]) {
        print(select.count)
    }

}
