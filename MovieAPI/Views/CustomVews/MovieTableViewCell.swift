//
//  MovieTableViewCell.swift
//  MovieAPI
//
//  Created by Mitya Kim on 2/2/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var movie: Movie? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Helper Methods
    func updateView() {
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.vote_average)"
        descriptionLabel.text = movie.overview
        
        MovieController.fetchImageFor(movie: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.movieImageView?.image = image
                case .failure(let error):
                    self.movieImageView?.image = UIImage(systemName: "photo.on.rectangle")
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
