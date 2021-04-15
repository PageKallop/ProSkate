//
//  SearchViewController.swift
//  ProSkate
//
//  Created by Page Kallop on 3/21/21.
//

import Foundation
import CoreLocation
import FloatingPanel

//creates protocal to select spot map
protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?)
   
}

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, FloatingPanelControllerDelegate  {

    
    var location = [searchLocation]()
    
    var delegate: SearchViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        //add elements to view
        view.addSubview(topLabel)
        view.addSubview(searchField)
        view.addSubview(listTableView)
        
        //sets delegates
        searchField.delegate = self
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = .secondarySystemBackground
    
    }
//MARK: - Constraints for view elements
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topLabel.sizeToFit()
        topLabel.frame = CGRect(x: 10, y: 10, width: topLabel.frame.size.width,
                                height: topLabel.frame.size.height)
        searchField.frame = CGRect(x: 10, y: 20 + topLabel.frame.size.height,
                                   width: view.frame.size.width - 20, height: 50)
        let tableY: CGFloat = searchField.frame.origin.y+searchField.frame.size.height+5
        listTableView.frame = CGRect(x: 0,
                                     y: tableY,
                                     width: view.frame.size.width,
                                     height: view.frame.size.height - tableY)
    }
    
//MARK: - UIElements
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "The Spot"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Spot"
        textField.layer.cornerRadius = 9
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        return textField
    }()
    
    let listTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       return tableview
    }()
    
//MARK: -TextField Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        
        if let textSearch = searchField.text, !textSearch.isEmpty{
            LocationManager.sharedLocation.findLocation(with: textSearch) { [weak self] locations in
    
                DispatchQueue.main.async {
                    self?.location = locations
                    self?.listTableView.reloadData()
                    
                }
        
            }
        }
        return true
    }

//MARK: -tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return location.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text = location[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let coordinate = location[indexPath.row].coordinates
        
        delegate?.searchViewController(self, didSelectLocationWith: coordinate)
        
    }

}
