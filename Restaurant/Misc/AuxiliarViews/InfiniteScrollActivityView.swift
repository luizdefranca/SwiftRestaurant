//
//  InfiniteScrollActivityView.swift
//  Restaurant
//
//  Created by Luiz on 7/17/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }

    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }

    func setupActivityIndicator() {
        activityIndicatorView.style = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }

    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }

    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}
