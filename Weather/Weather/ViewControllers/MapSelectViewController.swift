//
//  MapSelectViewController.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit

class MapSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up navigation
        self.setupNavigation()
    }
    
    func setupNavigation() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.isNavigationBarHidden = false
        self.navigationItem.title = "Weather"
        self.navigationItem.hidesBackButton = true
        
        let rightBar = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(onHistory))
        self.navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc func onHistory() {
        
    }

}
