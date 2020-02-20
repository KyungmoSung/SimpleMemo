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

  var memos: Results<Memo>?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    memos = RealmManager.shared.objects(Memo.self)

    memoCollectionView.delegate = self
    memoCollectionView.dataSource = self
    
    let memoCellNib = UINib(nibName: "MemoCell", bundle: nil)
    memoCollectionView.register(memoCellNib, forCellWithReuseIdentifier: "MemoCell")
  }
}

extension MemoListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let memo = memos?[indexPath.row] else {
      return
    }
    print(memo)
  }

}

extension MemoListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
       return CGSize.zero
    }
    
    let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
    return CGSize(width: value, height: value)
  }
}

extension MemoListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memos?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoCell", for: indexPath) as? MemoCell else {
      fatalError()
    }
    if let memo = memos?[indexPath.row] {
      cell.bind(memo: memo)
    }
    return cell
  }
}
