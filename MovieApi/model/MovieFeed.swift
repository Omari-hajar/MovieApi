//
//  MovieFeed.swift
//  MovieApi
//
//  Created by Hajar Alomari on 19/12/2021.
//

import UIKit

struct MovieFeed : Decodable{
    var title: String
    var image: String
    var description: String
    var director: String
    var release_date: String
    
}
