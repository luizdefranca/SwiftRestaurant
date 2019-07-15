//
//  ExploreViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/8/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController{



    @IBOutlet weak var collectionView: UICollectionView!
    private let manager : ExploreDataManager = ExploreDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupCollectionView()

    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: 100)
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }



}

extension ExploreViewController: UICollectionViewDelegate {

}

extension ExploreViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExplorerCollectionViewCell
        cell.exploreItem = manager.explore(at: indexPath)
        return cell
    }

    @IBAction func unwindLocationCancel(segue: UIStoryboardSegue) {
        
    }
}
