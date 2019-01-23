//
//  HistoryViewController.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import CoreLocation

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableViewHistory: UITableView!
    
    var history: [HistoryItem]?
    
    var deliveringCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableViewHistory.tableFooterView = UIView()
        
        DispatchQueue.global(qos: .background).async {
            self.history = CacheManager.manager.loadHistory()
            DispatchQueue.main.async {
                self.tableViewHistory.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "History"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sid_weather_details" {
            let controller = segue.destination as! WeatherDetailsViewController
            controller.fromHistory = true
            controller.coordinate = self.deliveringCoordinate
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")!
        
        guard let item = self.history?[indexPath.row] else {return UITableViewCell()}
        
        if let labelCoord = cell.viewWithTag(10) as? UILabel {
            labelCoord.text = item.coordString
        }
        
        if let labelTime = cell.viewWithTag(11) as? UILabel {
            labelTime.text = Date(timeIntervalSince1970: item.time!).toString(format: "hh:mm a")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.deliveringCoordinate = self.history![indexPath.row].coordinate()
        self.performSegue(withIdentifier: "sid_weather_details", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = self.history![indexPath.row]
            self.history!.remove(at: indexPath.row)
            
            DispatchQueue.global(qos: .background).async {
                CacheManager.manager.remove(item.coordinate())
            }
            
            self.tableViewHistory.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
