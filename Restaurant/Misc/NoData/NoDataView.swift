//
//  NoDataView.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    var view: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func loadViewFromNib() -> UIView{
        let nib = UINib(nibName: "NoDataView", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func setupView() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    func set(title: String){
        lblTitle.text = title
    }

    func set(desc: String) {
        lblDesc.text = desc
    }


}
