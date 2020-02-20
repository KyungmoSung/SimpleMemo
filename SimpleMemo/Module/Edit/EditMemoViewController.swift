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
  let imagePicker = UIImagePickerController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentTv.delegate = self
    contentTv.textContainerInset = .zero // textView 상하 padding 제거
    contentTv.textContainer.lineFragmentPadding = 0 // textView 좌우 padding 제거
    contentTv.text = "내용을 입력하세요"
    contentTv.textColor = UIColor.lightGray

    imagePicker.delegate = self
    imagePicker.allowsEditing = true

    imageCollectionView.dataSource = self
    imageCollectionView.delegate = self

    let attachImageCellNib = UINib(nibName: AttachImageCell.nibName, bundle: nil)
    imageCollectionView.register(attachImageCellNib, forCellWithReuseIdentifier: AttachImageCell.reuseIdentifier)

    let attachImageSelectCellNib = UINib(nibName: AttachImageSelectCell.nibName, bundle: nil)
    imageCollectionView.register(attachImageSelectCellNib, forCellWithReuseIdentifier: AttachImageSelectCell.reuseIdentifier)
  }

  /// 정보 미입력 에러 Alert 호출
  func presentFailAlert(message: String) {
    let alert = UIAlertController(title: "실패", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
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
}

// MARK: - UITextViewDelegate
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

// MARK: - UICollectionViewDataSource
extension EditMemoViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0: // 등록된 이미지 셀 섹션
      return images.count
    case 1: // 이미지 첨부 셀 섹션
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
      cell.bind(image: image, isThumbnail: (indexPath.row == 0))
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

// MARK: - UICollectionViewDelegate
extension EditMemoViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0: // 등록된 이미지 셀 섹션
      // TODO: 이미지 확대 보여주기
      ()
    case 1: // 이미지 첨부 셀 섹션
      let alert = UIAlertController(title: "이미지 첨부", message: "첨부 방식을 선택하세요", preferredStyle: .actionSheet)

      // 사진첩 선택 액션
      let albumAction = UIAlertAction(title: "사진첩", style: .default) { [weak self] _ in
        guard let imagePicker = self?.imagePicker else {
          return
        }
        imagePicker.sourceType = .photoLibrary
        self?.present(imagePicker, animated: true, completion: nil)
      }

      // 카메라 선택 액션
      let cameraAction = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
        guard let imagePicker = self?.imagePicker else {
          return
        }
        imagePicker.sourceType = .camera
        self?.present(imagePicker, animated: true, completion: nil)
      }

      // 외부링크 선택 액션
      let urlAction = UIAlertAction(title: "외부 이미지(URL)", style: .default) { _ in
        let inputAlert = UIAlertController(title: "외부 이미지 첨부", message: "이미지 URL을 입력하세요", preferredStyle: .alert)
        inputAlert.addTextField { (textField) in
          textField.placeholder = "https://example.com/image.png"
        }

        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak inputAlert] (_) in
          // 유효한 URL인지 확인
          if let urlText = inputAlert?.textFields?[0].text,
            let url = URL(string: urlText),
            UIApplication.shared.canOpenURL(url) {

            let image = Image(type: .url, url: urlText)
            self?.images.append(image)

            self?.imageCollectionView.reloadData()
          } else {
            self?.presentFailAlert(message: "올바른 이미지 URL이 아닙니다")
          }
        })

        inputAlert.addAction(okAction)

        self.present(inputAlert, animated: true, completion: nil)
      }

      let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

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

// MARK: - UICollectionViewDelegateFlowLayout
extension EditMemoViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let value = collectionView.frame.height
    return CGSize(width: value, height: value)
  }
}

// MARK: - AttachImageCellDelegate
extension EditMemoViewController: AttachImageCellDelegate {
  /// 첨부 이미지셀 삭제시
  func attachImageCell(_ attachImageCell: AttachImageCell, didDeleteImage image: Image) {
    guard let index = images.firstIndex(of: image) else {
      return
    }
    images.remove(at: index)
    imageCollectionView.reloadData()
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditMemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    var pickedImage: UIImage?
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { // 편집한 이미지가 있는 경우
      pickedImage = editedImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { // 원본 이미지가 있는 경우
      pickedImage = originalImage
    }

    if let pickedImage = pickedImage {
      var image: Image

      // 이미지 타입 지정
      switch picker.sourceType {
      case .photoLibrary, .savedPhotosAlbum:
        image = Image(type: .album, data: pickedImage.pngData())
      case .camera:
        image = Image(type: .camera, data: pickedImage.pngData())
      @unknown default:
        fatalError()
      }

      images.append(image)
      imageCollectionView.reloadData()
    }
    
    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}