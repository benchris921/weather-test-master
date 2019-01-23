//
//  ViewController.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* We will process splash here, loading, initializing data and so on.
         * On this test project, just simply showing 1 second activity indicator.
         * On the full project, should remove this 1 second delaying actually.
         */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.performSegue(withIdentifier: "sid_main", sender: nil)
            
            // Should be branched here,  to login or to home page.
            // in the test project, simply going into main page,  we have not created login system in test project.
        }
    }


}

