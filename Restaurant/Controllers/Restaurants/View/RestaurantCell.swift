//
//  RestaurantCellCollectionViewCell.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCuisine: UILabel!
    @IBOutlet weak var imgRestaurant: UIImageView!
    var restaurant: Restaurant? {
        didSet {
                lblTitle.text = self.restaurant?.name ?? "No name"
                lblCuisine.text = self.restaurant?.cuisines.joined(separator: " | ") ?? ""
                if let url = URL(string: restaurant?.imageURL ?? ""){

                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.imgRestaurant.image = UIImage(data: imageData)
                    }
                }
                else {
                    print("Cannot load image data from url - Error:  - \(#file) \(#line) \(#function)")
                }
            }

        }
    }

}
