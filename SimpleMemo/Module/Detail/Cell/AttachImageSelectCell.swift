//
//  AttachImageSelectCell.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

class AttachImageSelectCell: UICollectionViewCell, ReuseIdentifying {

  @IBOutlet var designableBackgroundView: DesignableView!

  override func awakeFromNib() {
    super.awakeFromNib()

    designableBackgroundView.backgroundColor = .lightGreyBackground
  }

}
