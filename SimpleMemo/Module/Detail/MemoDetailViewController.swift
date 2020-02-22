//
//  MemoDetailViewController.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import Nuke

class MemoDetailViewController: UIViewController {
  private enum Constants {
    static let collectionViewNonEditableSectionNumer = 1 // 상세일 경우 섹션 수
    static let collectionViewEditableSectionNumber = 2 // 수정,추가일 경우 섹션 수
    static let imageSection = 0 // 등록된 이미지 셀 섹션
    static let attachSection = 1 // 이미지 첨부 셀 섹션
  }

  @IBOutlet var titleTf: UITextField!
  @IBOutlet var contentTv: UITextView!
  @IBOutlet var imageContainerView: UIView!
  @IBOutlet var imageCollectionView: UICollectionView!
  @IBOutlet var addBtnContainerView: UIView!
  @IBOutlet var addBtn: UIButton!
  @IBOutlet var deleteBarBtn: UIBarButtonItem!
  @IBOutlet var editBarBtn: UIBarButtonItem!

  enum ViewType {
    case detail // 상세
    case edit // 수정
    case add // 추가
  }
  var viewType: ViewType = .detail

  let imagePicker = UIImagePickerController()
  var images: [Image] = []

  var memo: Memo?

  var isModified: Bool = false {
    didSet {
      addBtnContainerView.isHidden = !isModified
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let memo = memo {
      setupUI(viewType: .detail)
      titleTf.text = memo.title
      titleTf.textColor = .smText
      contentTv.text = memo.content
      contentTv.textColor = .smText

      images = Array(memo.images)
    } else {
      setupUI(viewType: .add)
    }

    titleTf.delegate = self

    contentTv.delegate = self
    contentTv.font = .systemFont(ofSize: 15)
    contentTv.textContainerInset = .zero // textView 상하 padding 제거
    contentTv.textContainer.lineFragmentPadding = 0 // textView 좌우 padding 제거

    imagePicker.delegate = self
    imagePicker.allowsEditing = true

    imageCollectionView.dataSource = self
    imageCollectionView.delegate = self

    let attachImageCellNib = UINib(nibName: AttachImageCell.nibName, bundle: nil)
    imageCollectionView.register(attachImageCellNib, forCellWithReuseIdentifier: AttachImageCell.reuseIdentifier)

    let attachImageSelectCellNib = UINib(nibName: AttachImageSelectCell.nibName, bundle: nil)
    imageCollectionView.register(attachImageSelectCellNib, forCellWithReuseIdentifier: AttachImageSelectCell.reuseIdentifier)
    
    hideKeyboardWhenTappedAround()
  }

  /// 뷰 타입에 따라 UI 세팅
  func setupUI(viewType: ViewType) {
    self.viewType = viewType

    switch viewType {
    case .detail:
      title = "MemoDetailTitle".localized
      deleteBarBtn.isEnabled = true
      deleteBarBtn.tintColor = .smBarButtonItemTint
      editBarBtn.isEnabled = true
      editBarBtn.tintColor = .smBarButtonItemTint

      titleTf.isEnabled = false
      contentTv.isEditable = false

      imageContainerView.isHidden = (memo?.images.count ?? 0) == 0
      addBtnContainerView.isHidden = true
    case .edit:
      title = "MemoEditTitle".localized
      deleteBarBtn.isEnabled = false
      deleteBarBtn.tintColor = .clear
      editBarBtn.isEnabled = false
      editBarBtn.tintColor = .clear

      titleTf.isEnabled = true
      contentTv.isEditable = true

      imageContainerView.isHidden = false
      addBtnContainerView.isHidden = false
      addBtn.setTitle("Complete".localized, for: .normal)
    case .add:
      title = "MemoAddTitle".localized
      deleteBarBtn.isEnabled = false
      deleteBarBtn.tintColor = .clear
      editBarBtn.isEnabled = false
      editBarBtn.tintColor = .clear

      titleTf.isEnabled = true
      contentTv.isEditable = true
      contentTv.text = "ConentsLabelPlaceholder".localized
      contentTv.textColor = .smPlaceholder

      imageContainerView.isHidden = false
      addBtnContainerView.isHidden = false
      addBtn.setTitle("Add".localized, for: .normal)
    }

    imageCollectionView.reloadData()
  }

  /// 정보 미입력 에러 Alert 호출
  func presentFailAlert(message: String) {
    let alert = UIAlertController(title: "Fail".localized, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Close".localized, style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func didTapBarBtn(_ sender: UIBarButtonItem) {
    switch sender {
    case editBarBtn: // 편집모드
      setupUI(viewType: .edit)
    case deleteBarBtn: // 삭제 alert 호출
      let alert = UIAlertController(title: "Delete".localized, message: "DeleteMemoMessage".localized, preferredStyle: .alert)
      let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] _ in
        if let memo = self?.memo {
          RealmManager.shared.delete([memo])
          self?.navigationController?.popViewController(animated: true)
        } else {
          fatalError("memo is nil")
        }
      }
      alert.addAction(deleteAction)
      let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      present(alert, animated: true, completion: nil)
    default:
      return
    }
  }

  /// 메모 저장
  @IBAction func didTapSaveBtn(_ sender: UIButton) {
    guard let title = titleTf.text, !title.isEmpty else { // 제목 미입력
      presentFailAlert(message: "TitleEmptyFail".localized)
      return
    }

    guard let content = contentTv.text, !title.isEmpty, contentTv.textColor != .smPlaceholder else { // 내용 미입력
      presentFailAlert(message: "ContentEmptyFail".localized)
      return
    }

    switch viewType {
    case .detail:
      return
    case .edit:
      guard let memo = memo else {
        return
      }
      RealmManager.shared.update { [weak self] in
        memo.title = title
        memo.content = content
        memo.images.removeAll()
        memo.images.append(objectsIn: self?.images ?? [])
      }
      setupUI(viewType: .detail)
    case .add:
      let memo = Memo()
      memo.title = title
      memo.content = content
      memo.images.append(objectsIn: images)
      RealmManager.shared.add([memo])
      navigationController?.popViewController(animated: true)
    }
  }
}

// MARK: - UITextViewDelegate
extension MemoDetailViewController: UITextViewDelegate {
  /// 내용 편집 시작시  placeholder 제거
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.smPlaceholder {
      textView.text = nil
      textView.textColor = .smText
    }
  }

  /// 내용 편집 종료시 내용이 없으면 placeholder 표시
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "ConentsLabelPlaceholder".localized
      textView.textColor = .smPlaceholder
    }
  }

  /// 내용 수정
  func textViewDidChange(_ textView: UITextView) {
    isModified = true
  }
}

// MARK: - UITextFieldDelegate
extension MemoDetailViewController: UITextFieldDelegate {
  /// 제목 수정
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    isModified = true
    return true
  }
}

// MARK: - UICollectionViewDataSource
extension MemoDetailViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewType == .detail ? Constants.collectionViewNonEditableSectionNumer : Constants.collectionViewEditableSectionNumber
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case Constants.imageSection: // 등록된 이미지 셀 섹션
      return images.count
    case Constants.attachSection: // 이미지 첨부 셀 섹션
      return 1
    default:
      fatalError()
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case Constants.imageSection:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachImageCell.reuseIdentifier, for: indexPath) as? AttachImageCell else {
        fatalError()
      }

      let image = images[indexPath.row]
      cell.bind(image: image, isThumbnail: (indexPath.row == 0), deletable: (viewType != .detail))
      cell.delegate = self
      return cell
    case Constants.attachSection:
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
extension MemoDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case Constants.imageSection: // 등록된 이미지 셀 섹션
      let imageSlider = ImageSliderViewController()
      imageSlider.images = Array(images)
      imageSlider.displayIndex = indexPath.row
      navigationController?.pushViewController(imageSlider, animated: true)
    case Constants.attachSection: // 이미지 첨부 셀 섹션
      let alert = UIAlertController(title: "AttachImage".localized, message: "SelectAttachType".localized, preferredStyle: .actionSheet)

      // 사진첩 선택 액션
      let albumAction = UIAlertAction(title: "Album".localized, style: .default) { [weak self] _ in
        guard let imagePicker = self?.imagePicker else {
          return
        }
        imagePicker.sourceType = .photoLibrary
        self?.present(imagePicker, animated: true, completion: nil)
      }

      // 카메라 선택 액션
      let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { [weak self] _ in
        guard let imagePicker = self?.imagePicker else {
          return
        }
        imagePicker.sourceType = .camera
        self?.present(imagePicker, animated: true, completion: nil)
      }

      // 외부링크 선택 액션
      let urlAction = UIAlertAction(title: "ExternalImage".localized, style: .default) { _ in
        let inputAlert = UIAlertController(title: "AttachExternalImage".localized, message: "InputImageURL".localized, preferredStyle: .alert)
        inputAlert.addTextField { (textField) in
          textField.placeholder = "https://example.com/image.png"
        }

        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: { [weak self, weak inputAlert] (_) in
          // 유효한 URL인지 확인
          if let urlText = inputAlert?.textFields?[0].text,
            let url = URL(string: urlText),
            UIApplication.shared.canOpenURL(url) {

            let image = Image()
            image.url = urlText
            self?.images.append(image)

            self?.imageCollectionView.reloadData()
          } else {
            self?.presentFailAlert(message: "NotImageURLFail".localized)
          }
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)

        inputAlert.addAction(okAction)
        inputAlert.addAction(cancelAction)

        self.present(inputAlert, animated: true, completion: nil)
      }

      let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)

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
extension MemoDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let value = collectionView.frame.height
    return CGSize(width: value, height: value)
  }
}

// MARK: - AttachImageCellDelegate
extension MemoDetailViewController: AttachImageCellDelegate {
  /// 첨부 이미지셀 삭제시
  func attachImageCell(_ attachImageCell: AttachImageCell, didDeleteImage image: Image) {
    guard let index = images.firstIndex(of: image) else {
      return
    }
    images.remove(at: index)
    isModified = true
    imageCollectionView.reloadData()
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MemoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    var pickedImage: UIImage?
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { // 편집한 이미지가 있는 경우
      pickedImage = editedImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { // 원본 이미지가 있는 경우
      pickedImage = originalImage
    }

    if let pickedImage = pickedImage {
      let image = Image()
      image.data = pickedImage.pngData()

      images.append(image)
      isModified = true
      imageCollectionView.reloadData()
    }

    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
