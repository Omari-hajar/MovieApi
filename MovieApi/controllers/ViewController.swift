//
//  ViewController.swift
//  MovieApi
//
//  Created by Hajar Alomari on 19/12/2021.
//

import UIKit
import CCAutocomplete
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AutocompleteDelegate {
 
    @IBOutlet weak var searchTextField: UITextField!
    
    let filmVCDelegate: FilmViewController? = nil
    
    
    var filmSegue: MovieFeed?
    var isFirstLoad: Bool = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    var autoCompleteViewController: AutoCompleteViewController!
    
    
    var result: [MovieFeed] = []
    let apiUrlString = "https://ghibliapi.herokuapp.com/films"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.isFirstLoad {
                   self.isFirstLoad = false
                   Autocomplete.setupAutocompleteForViewcontroller(self)
               }
       
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let itemSize = UIScreen.main.bounds.width/2 - 3
      

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 3

        collectionView.collectionViewLayout = layout
       
        
        fetchData()
    }

    func fetchData(){
        guard let url = URL(string: apiUrlString) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let jsonResults: [MovieFeed]  = try JSONDecoder().decode([MovieFeed].self, from: data)
                DispatchQueue.main.async {
                    self.result = jsonResults
                    self.collectionView.reloadData()
                    
                }
                print("Success")
            }catch{
                print("Failed to fetch data")
            }

        }
        task.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let image = result[indexPath.row].image
     
        cell.setImage(stringURL: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(result[indexPath.row].title) was clicked")
    
            filmSegue = result[indexPath.row]
        performSegue(withIdentifier: "FilmSegue", sender: nil)
        
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilmSegue" {
            if let cv = segue.destination as? FilmViewController {
                cv.film = filmSegue
            }
        }
    }
    

    //auto complete
    
    func autoCompleteTextField() -> UITextField {
        return searchTextField
    }
    
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }
    //find out why it returns double string
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        let filteredFilms = self.result.filter { (film) -> Bool in
            return film.title.lowercased().contains(term.lowercased())
        }
        let identifier = UUID()
        let filmsResults : [AutocompletableOption] = filteredFilms.map { (film) -> AutocompleteCellData in
            var film = film.title
            film.replaceSubrange(film.startIndex...film.startIndex, with: film)
            return AutocompleteCellData(uuid: identifier , text: film, image: nil)
                    }.map( { $0 as AutocompletableOption })
        return filmsResults
      
    }
    
    func autoCompleteHeight() -> CGFloat{
        return self.view.frame.height / 3.0
    }
    
    func didSelectItem(_ item: AutocompletableOption) {
        print(item.text)
        for film in result {
            if item.text.lowercased().contains(film.title.lowercased()){
               
               filmSegue = film
            
        } else{
            print("not found")
        }
        }
       
       performSegue(withIdentifier: "FilmSegue", sender: nil)
    }
 
}


