//
//  EditMemoViewController.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

class EditMemoViewController: UIViewController {

  @IBOutlet var titleTf: UITextField!
  @IBOutlet var contentTv: UITextView!
  @IBOutlet var imageCollectionView: UICollectionView!

  var images: [Image] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func setupUI() {
    contentTv.delegate = self
    contentTv.textContainerInset = .zero // textView 상하 padding 제거
    contentTv.textContainer.lineFragmentPadding = 0 // textView 좌우 padding 제거
    contentTv.text = "내용을 입력하세요"
    contentTv.textColor = UIColor.lightGray

    imageCollectionView.dataSource = self
    imageCollectionView.delegate = self

    let attachImageCellNib = UINib(nibName: AttachImageCell.nibName, bundle: nil)
    imageCollectionView.register(attachImageCellNib, forCellWithReuseIdentifier: AttachImageCell.reuseIdentifier)
    
    let attachImageSelectCellNib = UINib(nibName: AttachImageSelectCell.nibName, bundle: nil)
    imageCollectionView.register(attachImageSelectCellNib, forCellWithReuseIdentifier: AttachImageSelectCell.reuseIdentifier)
  }

  /// 메모 저장
  @IBAction func didTapSaveBtn(_ sender: Any) {
    guard let title = titleTf.text, !title.isEmpty else { // 제목 미입력
      presentFailAlert(message: "제목을 입력해주세요")
      return
    }
    guard let content = contentTv.text else { // 내용 미입력
      presentFailAlert(message: "내용을 입력해주세요")
      return
    }

    let memo = Memo()
    memo.title = title
    memo.content = content

    RealmManager.shared.add([memo])

    navigationController?.popViewController(animated: true)
  }

  func presentFailAlert(message: String) {
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

extension EditMemoViewController: UITextViewDelegate {
  /// 텍스트 편집 시작시  placeholder 제거
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.darkGray
    }
  }

  /// 텍스트 편집 종료시 내용이 없으면 placeholder 표시
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "내용을 입력하세요"
      textView.textColor = UIColor.lightGray
    }
  }
}

extension EditMemoViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return images.count
    case 1:
      return 1
    default:
      fatalError()
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachImageCell.reuseIdentifier, for: indexPath) as? AttachImageCell else {
        fatalError()
      }

      let image = images[indexPath.row]
      cell.bind(image: image, indexPath: indexPath)
      cell.delegate = self
      return cell
    case 1:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachImageSelectCell.reuseIdentifier, for: indexPath) as? AttachImageSelectCell else {
        fatalError()
      }
      return cell
    default:
      fatalError()
    }
  }
}

extension EditMemoViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      // TODO: 이미지 확대 보여주기
      ()
    case 1:
      let alert = UIAlertController(title: "이미지 첨부", message: "첨부 방식을 선택하세요", preferredStyle: .actionSheet)
      let albumAction = UIAlertAction(title: "사진첩", style: .default) { _ in

      }
      let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in

      }
      let urlAction = UIAlertAction(title: "외부 이미지(URL)", style: .default) { _ in

      }
      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in

      }
      alert.addAction(albumAction)
      alert.addAction(cameraAction)
      alert.addAction(urlAction)
      alert.addAction(cancelAction)
      present(alert, animated: true, completion: nil)
    default:
      fatalError()
    }
  }
}

extension EditMemoViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let value = collectionView.frame.height
    return CGSize(width: value, height: value)
  }
}

extension EditMemoViewController: AttachImageCellDelegate {
  func attachImageCell(_ attachImageCell: AttachImageCell, didDeleteItemAt indexPath: IndexPath) {
    images.remove(at: indexPath.row)
    imageCollectionView.reloadData()
  }
}
