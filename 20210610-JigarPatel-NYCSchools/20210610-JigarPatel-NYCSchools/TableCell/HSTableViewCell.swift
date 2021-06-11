//
//  HSTableViewCell.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//

import UIKit

class HSTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet var topView: UIView!
    @IBOutlet var schoolNameLbl: UILabel!
    @IBOutlet var schoolAddrLbl: UILabel!
    @IBOutlet var schoolPhoneNumBtn: UIButton!
    @IBOutlet var navigateToAddrBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Cell View Customization

    func setupView(){
        let view = topView
        view?.layer.cornerRadius = 15.0
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOffset = CGSize(width: 0, height: 2)
        view?.layer.shadowOpacity = 0.8
        view?.layer.shadowRadius = 3
        view?.layer.masksToBounds = false
    }

}
