//
//  MovieCell.swift
//  Week1Assignment
//
//  Created by Thomas Bender on 9/6/18.
//  Copyright © 2018 Thomas Bender. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var posterImageViewer: UIImageView!
  
  var movie: Movie!  {          //milestone 4
    didSet {
      titleLabel.text = movie.title
      overviewLabel.text = movie.overview
      let posterURL = movie.posterURL
      let posterPlaceholderImage = UIImage(named: "now_playing_tabbar_item")
      posterImageViewer.af_setImage(withURL: posterURL!, placeholderImage: posterPlaceholderImage)
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
