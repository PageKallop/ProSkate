//
//  LocationListViewController.swift
//  ProSkate
//
//  Created by Page Kallop on 3/21/21.
//

import Foundation
import Firebase

class LocationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

 
    var spotLocation : [locations] = []
    
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        view.backgroundColor = .black
        //sets delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        
        //adding elements to view
        tableViewConstraints()
        
        bottomElements()
        
        loadLocations()
        
        tableLabelConstraints()
        
        textLabelConstraints()
        
        //registers table view for reuse
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")
        
        // sets navbar color
        navigationController?.navigationBar.barTintColor = .white
        //adds barbutton item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(goToMap))
 
        
        
    //MARK: -Keyboard methods
        
        //adjust view for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
     
        //sets keyboard back
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      
        self.dismissKeyBoard()
        

    }
    
    //adjusts view to keyoboard
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }

    }
    //sets keyboard back
    @objc func keyboardWillHide(notification: NSNotification) {

        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }

    }
//dismisses keyboard
    func dismissKeyBoard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchingOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboardTouchingOutside(){
        view.endEditing(true)
    }

    
    // MARK: -UIElements
    
    let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let textField : UITextView = {
    let textField = UITextView(frame: CGRect(x: 20, y: 0, width: 40, height: 50))
    textField.contentInsetAdjustmentBehavior = .automatic
    textField.textAlignment = NSTextAlignment.justified
    textField.textColor = UIColor.black
    textField.backgroundColor = UIColor.white
        return textField
    }()
    
    let sendButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 35)
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let tableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shared Skate Spots"
        label.textAlignment = .center
        label.font = UIFont(name: "Chalkduster", size: 25)
        label.textColor = .white
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Share Spot"
        label.textAlignment = .center
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.textColor = .white
        return label
    }()
    
    //MARK: -UIConstraints
    
    func tableLabelConstraints() {
        view.addSubview(tableLabel)
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(tableLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6))
        constraints.append(tableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(tableLabel.widthAnchor.constraint(equalToConstant: 354))
        constraints.append(tableLabel.heightAnchor.constraint(equalToConstant: 33))
       
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func textLabelConstraints() {
        view.addSubview(textLabel)
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(textLabel.widthAnchor.constraint(equalToConstant: 250))
        constraints.append(textLabel.heightAnchor.constraint(equalToConstant: 47))
        constraints.append(textLabel.bottomAnchor.constraint(equalTo: textField.topAnchor,constant: -5))
        constraints.append(textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
       
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func tableViewConstraints() {
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300.0).isActive = true
    }
    
    func bottomElements() {
        let bottomStack = UIStackView(arrangedSubviews: [textField, sendButton])
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.distribution = .fill
        bottomStack.axis = .vertical
        bottomStack.spacing = 20
        view.addSubview(bottomStack)
        
        bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -65).isActive = true
        bottomStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        bottomStack.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
//MARK:- VC navigation

    //presents mapvc
    @objc func goToMap(){
        let mapVC = MapViewController()
        let navVC = UINavigationController(rootViewController: mapVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
//MARK: -Saving and retrieving data
    
    //sends and saves location message to firestore
    @objc func sendButtonClicked() {
        
        if let location = textField.text {
            db.collection("locationName").addDocument(data: ["locationName": location, "date": Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("error saving data \(e)")
                } else{
                    print("data saved")
                    
                    self.textField.text = ""
                    
                    
                }
            }
            
        }
    }
    
    //load lactions from firestore
    func loadLocations(){
        
        db.collection("locationName").addSnapshotListener { (querySnapshot, error) in
            
            self.spotLocation = []
            
            if let e = error {
                print("Error retrieving data\(e)")
            } else {
               
                if let newDoc = querySnapshot?.documents {
                    for doc in newDoc {
                        print(doc.data())
                    let data = doc.data()
                        if let locationSpot = data["locationName"] as? String {
                            let newSpot = locations(spotLocation: locationSpot)
                            self.spotLocation.append(newSpot)
                          
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                let indexPath = IndexPath(row: self.spotLocation.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
 
                        }
                    }
                }
            }
        }
    }
    
 
    
// MARK: - Tableview Methods

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let spot = spotLocation[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        cell.textLabel?.text = spot.spotLocation
        cell.textLabel?.numberOfLines = 0
         return cell
     }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spotLocation.count
    }

     // MARK: - Table view delegate

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // etc
     }


}
