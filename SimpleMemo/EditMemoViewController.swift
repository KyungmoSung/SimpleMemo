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
  }
  
  /// 메모 저장
  @IBAction func didTapSaveBtn(_ sender: Any) {
    guard let title = titleTf.text else { // 제목 미입력
      return
    }
    guard let content = contentTv.text else { // 내용 미입력
      return
    }
    
    let memo = Memo()
    memo.title = title
    memo.content = content
    
    RealmManager.shared.add([memo])
    
    navigationController?.popViewController(animated: true)
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
