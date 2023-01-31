//
//  PosterView.swift
//  Movie Time
//
//  Created by Arpit Singh on 31/01/23.
//

import UIKit
import Nuke
class PosterView: UIView {
    
    private let imageView = UIImageView()
    private let comicCard = ComicCard()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = comicCard.radius
        imageView.layer.masksToBounds = true
        comicCard.pinToParent(view: self)
        imageView.pinToParent(view: comicCard.contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from: URL?) {
        guard let url = from else { return }
        Nuke.loadImage(with: url, into: imageView)
    }
    
}
