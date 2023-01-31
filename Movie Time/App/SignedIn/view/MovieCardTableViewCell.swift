//
//  MovieCardTableViewCell.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit

class MovieCardTableViewCell: UITableViewCell {

    private let comicCard =  ComicCard()
    private let poster = PosterView()
    private let padding: CGFloat = 15
    
    public static var cellID: String { "Movie.Time.cell" }
   
    private let yearTag: TagView = {
        let tag = TagView()
        tag.backgroundColor = ColorResource.appYellow
        return tag
    }()
    
    private let typeTag: TagView = {
        let tag = TagView()
        tag.backgroundColor = ColorResource.secondaryColor
        return tag
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .appFontStyle(.heading)
        label.textColor = ColorResource.appBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorResource.backgroundColor
        setupComicCard()
        setupPosterView()
        setupLabel()
        setupTages()
    }
    
   private func setupLabel() {
        comicCard.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topConstraint(comicCard.contentView.topAnchor,padding: padding)
            .rightConstraint(comicCard.contentView.rightAnchor,padding: -padding)
            .leftConstraint(poster.rightAnchor,padding: padding)
    
    }
    
  private  func setupPosterView() {
        contentView.addSubview(poster)
        let width: CGFloat = frame.width * 0.5
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster
            .leftConstraint(comicCard.contentView.leftAnchor,padding: 10)
            .setCenterY(comicCard.topAnchor)
            .setHeight(width)
            .topConstraint(contentView.topAnchor,padding: padding)
            .widthEqual(poster.heightAnchor,percent: 0.8)
            
    }
    
  private  func setupComicCard() {
        contentView.addSubview(comicCard)
        comicCard.translatesAutoresizingMaskIntoConstraints = false
        comicCard.leftConstraint(contentView.leftAnchor,padding: padding)
            .rightConstraint(contentView.rightAnchor,padding: -padding)
            .bottomConstraint(contentView.bottomAnchor,padding: -padding)
        comicCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
  private func setupTages() {
        let stack = UIStackView(arrangedSubviews: [typeTag,yearTag])
        stack.axis = .horizontal
      stack.distribution = .fillProportionally
        stack.spacing = 7
        comicCard.contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topConstraint(title.bottomAnchor,padding: padding)
            .bottomConstraint(comicCard.contentView.bottomAnchor,padding: -padding * 2)
            .leftConstraint(title.leftAnchor)
      stack.rightAnchor.constraint(lessThanOrEqualTo: comicCard.contentView.rightAnchor, constant: -padding).isActive = true
    }
    
    public func setTo(movie: Movie) {
        title.text = movie.title
        poster.loadImage(from: movie.poster)
        yearTag.set(title: "\(movie.year)")
        typeTag.set(title: movie.type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
