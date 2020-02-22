//
//  MemoListViewController.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
  @IBOutlet var memoCollectionView: UICollectionView!
  @IBOutlet var changeGridStyleBarBtn: UIBarButtonItem!
  @IBOutlet var addMemoBarBtn: UIBarButtonItem!
  
  var numberOfItemInRow = 2 {
    didSet {
      changeGridStyleBarBtn.image = UIImage(named: "icGrid\(numberOfItemInRow)")
    }
  }
  
  var memos: Results<Memo>?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    changeGridStyleBarBtn.tintColor = .smBarButtonItemTint
    addMemoBarBtn.tintColor = .smBarButtonItemTint
    
    memoCollectionView.delegate = self
    memoCollectionView.dataSource = self

    let memoCellNib = UINib(nibName: MemoCell.nibName, bundle: nil)
    memoCollectionView.register(memoCellNib, forCellWithReuseIdentifier: MemoCell.reuseIdentifier)
  }

  override func viewWillAppear(_ animated: Bool) {
    memos = RealmManager.shared.objects(Memo.self).sorted(byKeyPath: "updateDate", ascending: false)
    memoCollectionView.reloadData()
  }
  
  @IBAction func didTapChangeGridStyleBarBtn(_ sender: Any) {
    if numberOfItemInRow <= 1 { // 한줄에 최대 3개까지
      numberOfItemInRow = 3
    } else {
      numberOfItemInRow -= 1
    }
    self.memoCollectionView.performBatchUpdates({ [weak self] in
      self?.memoCollectionView.reloadData()
      
    }, completion: nil)
  }
}

extension MemoListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let memo = memos?[indexPath.row] else {
      return
    }
    // 메모 상세 화면으로 이동
    if let vc: MemoDetailViewController = storyboard?.instantiateVC() {
      vc.memo = memo
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension MemoListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
        return CGSize.zero
    }
    let totalMinimumInteritemSpacing = (numberOfItemInRow > 1) ? (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemInRow)) : 0 // 전체 셀 간의 간격
    let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + totalMinimumInteritemSpacing)) / CGFloat(numberOfItemInRow)
    return CGSize(width: value, height: value * 7 / 5)
  }
}

extension MemoListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memos?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoCell.reuseIdentifier, for: indexPath) as? MemoCell else {
      fatalError()
    }
    if let memo = memos?[indexPath.row] {
      cell.bind(memo: memo)
    }
    return cell
  }
}
