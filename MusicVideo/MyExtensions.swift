//
//  MyExtensions.swift
//  MusicVideo
//
//  Created by Stellz on 3/29/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit

//When you write extensions to classes in seperate source file, make sure they are well documented so it won't be confusing to the other team developers

extension MusicVideoTVC: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        performSearch(searchController.searchBar.text!)
    }
}