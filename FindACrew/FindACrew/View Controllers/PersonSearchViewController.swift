//
//  PersonSearchViewController.swift
//  FindACrew
//
//  Created by Cody Morley on 4/6/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit

class PersonSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  
    private let personController = PersonController()
    private lazy var dataSource = makeDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = dataSource
        
    }
    
    private func searchWith(searchTerm: String) {
        activityIndicator.startAnimating()
        
        personController.searchForPeopleWith(searchTerm: searchTerm) {
            DispatchQueue.main.async {
                self.update()
            }
        }
    }
}

// MARK: - UITableViewDiffableDataSource

extension PersonSearchViewController {
    enum Section {
        case main
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Person> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, person in
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
            
            cell.person = person
            return cell
        }
    }
    
    private func update() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
        snapshot.appendSections([.main])
        snapshot.appendItems(personController.people)
        dataSource.apply(snapshot, animatingDifferences: true)
        activityIndicator.stopAnimating()
    }
}



extension PersonSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchBar.resignFirstResponder()
        searchWith(searchTerm: searchTerm)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            personController.people = []
            update()
            return
        }
        
        searchWith(searchTerm: searchText)
    }
}


extension PersonSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
        let person = personController.people[indexPath.row]
        dump(person)
    }
}
