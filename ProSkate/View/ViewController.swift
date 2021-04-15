//
//  ViewController.swift
//  ProSkate
//
//  Created by Page Kallop on 3/21/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //loads UIElements
        setImageView()
        labelConstraints()
        view.addSubview(slideButton)
        buttonConstraints()
     
    }
    
    //MARK: - UIElements
    
    //background Image
    
    let backgroundImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "board"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
       
    }()
 
    //app Label
    
    let applabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You Kno The Spot?"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "Chalkduster", size: 45)
        label.textColor = .red
        return label
    }()
    
    //slide button
    
    let slideButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Slide", for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 35)
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(slideButttonClicked), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: -UIButton function
    
    //slideButton function to present Location List VC
    
    @objc func slideButttonClicked(){
        let locationVC = LocationListViewController()
        let navVC = UINavigationController(rootViewController: locationVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        
    }
    
    //MARK: -Constraints for UIElements
  
    //sets constraints for background image
    func setImageView() {
        
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    //constraints for app label
    func labelConstraints(){
        view.addSubview(applabel)
        applabel.topAnchor.constraint(equalTo: view.topAnchor, constant: -300).isActive = true
        applabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        applabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        applabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30).isActive = true
    }

    //constraints for slide button
    func buttonConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(slideButton.widthAnchor.constraint(equalToConstant: 250))
        constraints.append(slideButton.heightAnchor.constraint(equalToConstant: 47))
        constraints.append(slideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -40))
        constraints.append(slideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
       
        NSLayoutConstraint.activate(constraints)
        
        
    }
    

}


