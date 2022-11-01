//
//  PhotoListViewController.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation
import UIKit

class PhotoListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var searchController: UISearchController!

    private let DETAILS_VC_IDENTIFIER = "DetailsView"
    
    lazy var viewModel = {
        PhotoListViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
       // initViewModel()
    }

    func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
      
        tableView.register(PhotoCell.nib, forCellReuseIdentifier: PhotoCell.identifier)
    }
}

// MARK: - UITableViewDelegate

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: DETAILS_VC_IDENTIFIER, sender: indexPath)
    }

}

// MARK: - UITableViewDataSource

extension PhotoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photoCellViewModel.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
   
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == DETAILS_VC_IDENTIFIER,
            let destination = segue.destination as? DetailsViewController
         {
             let cellVM = viewModel.getCellViewModel(at: (sender as! IndexPath))
             destination.photoID = cellVM.photoID
         }
     }
}

extension PhotoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            viewModel.searchPhoto(searchText) { [self] success, results, error in
                // Reload TableView closure
                if(success) {
                viewModel.reloadTableView = { [weak self] in
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
}
