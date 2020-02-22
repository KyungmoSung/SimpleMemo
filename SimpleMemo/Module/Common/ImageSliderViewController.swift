//
//  ImageSliderViewController.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/22.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import SnapKit
import Nuke

class ImageSliderViewController: UIViewController {

  var scrollView = UIScrollView()
  var imageStackView = UIStackView()
  var images: [Image] = []
  var displayIndex = 0 {
    didSet {
      title = "\(displayIndex + 1) / \(images.count)"
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // 스크롤뷰 세팅
    view.addSubview(scrollView)
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    scrollView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.edges.equalTo(view.safeAreaLayoutGuide)
      } else {
        make.edges.equalTo(view)
      }
    }

    // 이미지 수평 스택뷰 세팅
    scrollView.addSubview(imageStackView)
    imageStackView.axis = .horizontal
    imageStackView.alignment = .fill
    imageStackView.distribution = .fillEqually
    imageStackView.spacing = 0
    imageStackView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
      make.height.equalToSuperview()
      make.width.equalToSuperview().priority(.low)
    }

    // 이미지뷰 세팅
    for image in images {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit

      switch image.type {
      case .data:
        if let imageData = image.data {
          imageView.image = UIImage(data: imageData)
        }
      case .url:
        if let imageStringURL = image.url, let imageUrl = URL(string: imageStringURL) {
          let options = ImageLoadingOptions(
            placeholder: UIImage(named: "imagePlaceholder"),
            transition: .fadeIn(duration: 0.33)
          )
          Nuke.loadImage(with: imageUrl, options: options, into: imageView)
        }
      }

      imageStackView.addArrangedSubview(imageView)
      imageView.snp.makeConstraints { (make) in
        make.width.equalTo(view)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollToPage(page: displayIndex, animated: false)
  }

  /// 페이지 인덱스로 이동
  func scrollToPage(page: Int, animated: Bool) {
    var contentOffset = scrollView.contentOffset
    contentOffset.x = scrollView.bounds.size.width * CGFloat(page)
    scrollView.setContentOffset(contentOffset, animated: animated)
  }
}

extension ImageSliderViewController: UIScrollViewDelegate {

  /// 스크롤시 페이지 인덱스 계산
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.bounds.size.width
    displayIndex = Int(ceil(scrollView.contentOffset.x / pageWidth))
  }
}
