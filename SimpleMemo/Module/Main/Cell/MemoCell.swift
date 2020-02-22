//
//  MemoCell.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import Nuke

class MemoCell: UICollectionViewCell, ReuseIdentifying {
  @IBOutlet var containerView: DesignableView!
  @IBOutlet var thumbnailIv: UIImageView!
  @IBOutlet var contentStackView: UIStackView!
  @IBOutlet var titleLb: UILabel!
  @IBOutlet var contentLb: UILabel!
  
  private var shadowLayer: CAShapeLayer!
  private var cornerRadius: CGFloat = 25.0

    override func awakeFromNib() {
        super.awakeFromNib()
      containerView.backgroundColor = .smBackground
    }
  
  func bind(memo: Memo) {
    if let image = memo.images.first {
      thumbnailIv.isHidden = false
      titleLb.numberOfLines = 1
      contentLb.numberOfLines = 0
      
      switch image.type {
      case .data:
        if let imageData = image.data {
          thumbnailIv.image = UIImage(data: imageData)
        }
      case .url:
        if let imageStringURL = image.url, let imageUrl = URL(string: imageStringURL) {
          let options = ImageLoadingOptions(
              placeholder: UIImage(named: "imagePlaceholder"),
              transition: .fadeIn(duration: 0.33)
          )
          Nuke.loadImage(with: imageUrl, options: options, into: thumbnailIv)
        }
      }
    } else {
      thumbnailIv.isHidden = true
      titleLb.numberOfLines = 2
      contentLb.numberOfLines = 0
    }
    
    titleLb.text = memo.title
    contentLb.text = memo.content
  }
}
