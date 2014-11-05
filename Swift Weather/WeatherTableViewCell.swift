//
//  WeatherTableViewCell.swift
//  Swift Weather
//
//  Created by pang on 14-11-3.
//  Copyright (c) 2014年 rushjet. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
 
    @IBOutlet weak var temp: UILabel!
    
    
    @IBOutlet weak var wind: UILabel!
//    @IBOutlet weak var weatherDesp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
