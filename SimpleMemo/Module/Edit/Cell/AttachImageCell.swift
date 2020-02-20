//
//  AttachImageCell.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import Nuke

protocol AttachImageCellDelegate: class {
  func attachImageCell(_ attachImageCell: AttachImageCell, didDeleteImage image: Image) // 셀 삭제 버튼 클릭시
}

class AttachImageCell: UICollectionViewCell, ReuseIdentifying {
  @IBOutlet var attachIv: UIImageView!
  @IBOutlet var thumbnailMarkView: DesignableView!
  
  weak var delegate: AttachImageCellDelegate?
  var image: Image?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func bind(image: Image, isThumbnail: Bool) {
    self.image = image
    thumbnailMarkView.isHidden = !isThumbnail

    switch image.type {
    case .album,
       .camera:
      if let imageData = image.data {
        attachIv.image = UIImage(data: imageData)
      }
    case .url:
      if let imageStringURL = image.url, let imageUrl = URL(string: imageStringURL) {
        let options = ImageLoadingOptions(
          placeholder: UIImage(named: "placeholder"),
          transition: .fadeIn(duration: 0.33)
        )
        Nuke.loadImage(with: imageUrl, options: options, into: attachIv)
      }
    }
  }

  /// 삭제 버튼 클릭시 Delegate 전달
  @IBAction func didTapDeleteBtn(_ sender: Any) {
    guard let image = image else {
      return
    }
    delegate?.attachImageCell(self, didDeleteImage: image)
  }
}