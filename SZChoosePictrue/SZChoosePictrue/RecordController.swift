//
//  RecordController.swift
//  SZChoosePictrue
//
//  Created by 吴三忠 on 16/6/23.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

import UIKit

class RecordController: UITableViewController {
    
    var dataSource: [AnyObject]! {
        
        get {
            var tempArray = [NSDictionary]()
            RecordDataTool.shareRecord().queue.inDatabase { (db) in
                do {
                    let rs = try db.executeQuery("select name, time, step from Record_score", values: nil)
                    while rs.next() {
                        let name = rs.stringForColumn("name")
                        let time = rs.stringForColumn("time")
                        let step = rs.stringForColumn("step")
                        let dictM = ["name":name, "time":time, "step":step]
                        tempArray.append(dictM)
                    }
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
            }
            return tempArray
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dict: NSDictionary = dataSource[indexPath.row] as! NSDictionary
        var cell = tableView.dequeueReusableCellWithIdentifier("recordCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "recordCell")
        }
        cell?.textLabel?.text = dict["name"] as? String
        cell?.detailTextLabel?.text = "用时 \(dict["time"]!) s  移动 \(dict["step"]!) 步"
        return cell!
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        btn.backgroundColor = UIColor.init(colorLiteralRed: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
        btn.setTitle("返回", forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(clickBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func clickBackButton(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
