//
//  FilmViewController.swift
//  MovieApi
//
//  Created by Hajar Alomari on 20/12/2021.
//

import UIKit

class FilmViewController: UIViewController, FilmDelegate {
   
    

    @IBOutlet weak var filmPosterIV: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var descriptionTV: UITextView!
    
    var film: MovieFeed?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let film = film {
            sendFilm(item: film)
        }
       
        
    }
    
    
    func sendFilm(item: MovieFeed) {
        
        filmTitleLabel.text = item.title
        dateLabel.text = item.release_date
        descriptionTV.text = item.description
        directorLabel.text = item.director

        guard let url = URL(string: item.image) else{
            return
        }
       URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.filmPosterIV.image = image
                
                
            }

        }.resume()
        
    }
    


}
