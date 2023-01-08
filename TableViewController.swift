//
//  TableViewController.swift
//  _hw_02_seyhunkocak_
//
//  Created by Seyhun Koçak on 5.01.2023.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var currencies: [Currency] = []
    var rates  = [String : Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCellIdentifier")
        
        fetchData()

    }
   
    
    
    private func fetchData() {
        
        
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=3f4ad25b047ab4f70346c5c9a63c511a")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                
            } else {
                if data != nil {
                    do {
                        
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        DispatchQueue.main.async {
                            
                            if let rates = jsonResponse["rates"] as? [String : Double] {
                                
                                
                                self.rates = rates.filter({$0.key != "EUR"})
                                
                            }
                            self.tableView.reloadData()
                            
                        }
                    } catch {
                        print("error")
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }

}

extension TableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
extension TableViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCellIdentifier", for: indexPath) as! CurrencyCell
        
    
        cell.codeLabel.text = "EUR / \(Array(rates.keys)[indexPath.row])"
        cell.rateLabel.text = String(rates[Array(rates.keys)[indexPath.row]] ?? 0)
    
        return cell
    }
    
}
