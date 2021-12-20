//
//  FilmDelegate.swift
//  MovieApi
//
//  Created by Hajar Alomari on 20/12/2021.
//

import Foundation

protocol FilmDelegate: AnyObject{
    
    func sendFilm(item: MovieFeed)
}
