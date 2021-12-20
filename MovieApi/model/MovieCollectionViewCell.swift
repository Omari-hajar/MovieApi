//
//  MovieCollectionViewCell.swift
//  MovieApi
//
//  Created by Hajar Alomari on 20/12/2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filmIV: UIImageView!
    
    
    func setImage(stringURL: String){
        guard let url = URL(string: stringURL) else{
            return
        }
       URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.filmIV.image = image
            }

        }.resume()
        
    }
}
