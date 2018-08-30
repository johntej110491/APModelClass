//
//  TipsDetailVC.swift
//  DietApp
//
//  Created by user on 20/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit

class TipsDetailVC: UIViewController {

    @IBOutlet weak var constant_readmore_height: NSLayoutConstraint!
    @IBOutlet weak var tbl: UITableView!
    var getDetail = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let margin = self.view.frame.size.height - 250
        if tbl.contentSize.height < margin {
            constant_readmore_height.constant = tbl.contentSize.height
        }else{
            constant_readmore_height.constant = margin
        }
    }
    
    
    @IBAction func action_dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    

}


extension TipsDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TipsDetailCell
        //dailyTipsModel
        cell.lblTitle.text = self.getDetail
        return cell
    }
    
    
}
