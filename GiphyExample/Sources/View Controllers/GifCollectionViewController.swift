//
//  GifCollectionViewController.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/8/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import UIKit

class GifCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var searchController: UISearchController?

    private var recentSearchTermsStore = RecentSearchTermsStore.shared
    private let gifCellReuseID = "gifCell"
    private let recentTermID = "recentTermCell"
    
    private var recentTerms = [String]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var gifs = [Gif]() {
        didSet {
            collectionView?.reloadData()
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpSearchController()
        
        let numberOfCellsPerRow: CGFloat = 2
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1) * horizontalSpacing)/numberOfCellsPerRow - 10
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
        
        activityIndicator.center = view.center
        
        recentSearchTermsStore.getSearchTerms { [weak self] terms in
            self?.recentTerms = terms
        }
    }
    
    func setUpSearchController() {
        let gifSearchController = UISearchController(searchResultsController: nil)
        gifSearchController.searchBar.searchBarStyle = .minimal
        gifSearchController.searchBar.autocapitalizationType = .none
        gifSearchController.searchBar.autocorrectionType = .no
        gifSearchController.searchBar.sizeToFit()
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = gifSearchController
        searchController = gifSearchController
        searchController?.searchBar.delegate = self
    }

    func search(forGif searchTerm: String) {
        activityIndicator?.startAnimating()
        GiphyAPIClient.shared.searchGif(for: searchTerm, completion: { [weak self] gifs in
            self?.navigationItem.title = searchTerm.capitalized
            self?.gifs = gifs
            self?.activityIndicator.stopAnimating()
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.isEmpty ? recentTerms.count : gifs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchTermsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchTermCell", for: indexPath) as? SearchTermCollectionViewCell
        let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: gifCellReuseID, for: indexPath) as? GifCollectionViewCell
        
        if gifs.isEmpty {
            searchTermsCell?.textLabel.text = recentTerms[indexPath.row]
            return searchTermsCell ?? SearchTermCollectionViewCell()
        }
        
        let gif = gifs[indexPath.row]
       
        DispatchQueue.global(qos: .default).async {
            do {
                let gifData = try Data(contentsOf: gif.url)
                let gif = UIImage.gif(data: gifData)
                
                DispatchQueue.main.async(execute: {
                    gifCell?.imageView.image = gif
                })
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        
        return gifCell ?? GifCollectionViewCell()
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if
            let cell = collectionView.cellForItem(at: indexPath) as? SearchTermCollectionViewCell,
            let term = cell.textLabel.text
        {
            search(forGif: term)
        }
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let cell = sender as? GifCollectionViewCell,
            let image = cell.imageView.image,
            let destination = segue.destination as? GifDetailViewController
        {
            destination.gif = image
        }
    }
    
    //MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            search(forGif: term)
            recentSearchTermsStore.saveSearchTerm(term)
        }
        searchBar.resignFirstResponder()
        searchController?.isActive = false
    }
}
