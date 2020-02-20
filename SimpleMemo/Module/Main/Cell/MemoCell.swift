//
//  MemoCell.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import Nuke

class MemoCell: UICollectionViewCell {
  @IBOutlet var thumbnailIv: UIImageView!
  @IBOutlet var titleLb: UILabel!
  @IBOutlet var contentLb: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
  
  func bind(memo: Memo) {
    if let image = memo.images.first {
      switch image.type {
      case .album, .camera:
        if let imageData = image.data {
          thumbnailIv.image = UIImage(data: imageData)
        }
      case .url:
        if let imageStringURL = image.url, let imageUrl = URL(string: imageStringURL) {
          let options = ImageLoadingOptions(
              placeholder: UIImage(named: "placeholder"),
              transition: .fadeIn(duration: 0.33)
          )
          Nuke.loadImage(with: imageUrl, options: options, into: thumbnailIv)
        }
      }
    }
    
    titleLb.text = memo.title
    contentLb.text = memo.content
  }
}
