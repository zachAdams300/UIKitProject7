//
//  ViewController.swift
//  UIKitProject7
//
//  Created by Zachary Adams on 1/11/24.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let creditsButton = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(didTapCreditsButton))
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(didTapFilterButton))
        navigationItem.rightBarButtonItems = [creditsButton, filterButton]
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    @objc func didTapCreditsButton() {
        let ac = UIAlertController(title: "Credits", message: "This data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    @objc func didTapFilterButton() {
        let ac = UIAlertController(title: "Enter Search Criteria", message: nil, preferredStyle: .alert)
            ac.addTextField()
        ac.textFields![0].text = filterString
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac, weak self] _ in
            let answer = ac.textFields![0]
            self?.filterResults(answer.text?.lowercased() ?? "")
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    func filterResults(_ searchString: String) {
        filterString = searchString
        
        if searchString.count == 0 {
            filteredPetitions = petitions
        }else {
            filteredPetitions = petitions.filter{ petition in
                return petition.title.lowercased().contains(searchString)
            }
        }
        
        tableView.reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(PetitionList.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var contentView = cell.defaultContentConfiguration()
        contentView.text = filteredPetitions[indexPath.row].title
        contentView.textProperties.numberOfLines = 2
        contentView.secondaryText = filteredPetitions[indexPath.row].body
        contentView.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = contentView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
