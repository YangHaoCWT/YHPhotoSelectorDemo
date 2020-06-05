//
//  GroupingCell.swift
//  YHPhotoSelectorDemo
//
//  Created by Mac on 2019/3/18.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit
import Photos


let cellHeight = UIScreen.main.bounds.size.width / 5

class YHGroupingCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        contentView.addSubview(groupImageView)

        contentView.addSubview(countLabel)

    }

    lazy var countLabel: UILabel = {
        let countLabel = UILabel.init(frame: CGRect.init(x: groupImageView.frame.maxX + 10, y: groupImageView.frame.minY, width: contentView.bounds.size.width - (groupImageView.frame.maxX + 10), height: groupImageView.frame.height))
        return countLabel
    }()

    lazy var groupImageView: UIImageView = {
        let groupImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: cellHeight, height: cellHeight))
        groupImageView.contentMode = .scaleAspectFill
        groupImageView.clipsToBounds = true
        return groupImageView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension YHGroupingCell {

    func setImgeViewLabelUI(asset:PHAsset?, listName:String?, listCount:String?) {

        guard let phAsset = asset, let name = listName, let count = listCount else {
            return
        }

        let countTitleAttrString = NSMutableAttributedString.init(string: name + count)

        countTitleAttrString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)], range: NSRange.init(location: 0, length: name.count))

        countTitleAttrString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange.init(location: name.count, length: count.count))

        countLabel.attributedText = countTitleAttrString

        /// Waiting Optimize...
        PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize.init(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (image, info) in

            DispatchQueue.main.async {
                self.groupImageView.image = image
            }

        }

    }

}
