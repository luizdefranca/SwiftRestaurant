//
//  ExplorerCollectionViewCell.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class ExplorerCollectionViewCell: UICollectionViewCell {
    var exploreItem : ExploreItem? {
        didSet {
            imgExplore.image = UIImage(named: self.exploreItem!.image)
            lblName.text = self.exploreItem?.name
        }
    }
    @IBOutlet weak var imgExplore: UIImageView!
    @IBOutlet weak var lblName: UILabel!

}
