//
//  GameController.swift
//  SZChoosePictrue
//
//  Created by 吴三忠 on 16/6/22.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

import UIKit

class GameController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    internal var imageArray: [UIImage]!
    internal var image: UIImage!
    internal var count: Int!
    var emptyCell: GameViewCell?
    var stepValue: Int? = 0
    var timer: NSTimer!
    var time: Int? = 0
    var name: String?
    
    var newImageArray:[UIImage]!
    
    
    @IBOutlet weak var gameImageView: UICollectionView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var viewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBAction func clickSetButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clickRestartButton(sender: UIButton) {
        
        timer.invalidate()
        time = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(creatTime), userInfo: nil, repeats: true)
        timer.fire()
        stepLabel.text = String(0)
        stepValue = 0
        newImageArray = changeArrayOrder(imageArray)
        gameImageView .reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImageView.image = image
        newImageArray = changeArrayOrder(imageArray)
        gameImageView.dataSource = self
        gameImageView.delegate = self
        topConstraint.constant = (view.frame.size.width == CGFloat(320) ?10:50)
        let imageWidth = CGFloat(gameImageView.frame.width - CGFloat(count!) - 1)/CGFloat(count!)
        viewFlowLayout.itemSize = CGSize(width: imageWidth, height: imageWidth)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(creatTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gameCell", forIndexPath: indexPath) as! GameViewCell
        cell.index = indexPath.item
        cell.imageView.image = nil
        if indexPath.item < newImageArray.count {
            cell.imageView.image = newImageArray![indexPath.item]
        }
        else {
            emptyCell = cell
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView .cellForItemAtIndexPath(indexPath) as! GameViewCell
        let value = abs(cell.index - emptyCell!.index)
        if value == count || (value == 1 && cell.index/count! == emptyCell!.index/count!) {
            emptyCell?.imageView.image = cell.imageView.image
            cell.imageView.image = nil
            emptyCell = cell
            stepValue! += 1
            stepLabel.text = String(stepValue!)
        }
        if emptyCell!.index == imageArray!.count - 1 {
            var isComplete: Bool? = true
            for i in 0..<imageArray!.count - 1 {
                let indexPath: NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
                let cell = gameImageView.cellForItemAtIndexPath(indexPath) as! GameViewCell
                let isSame = cell.imageView.image == imageArray[i]
                isComplete = isComplete == isSame
                if isComplete == false {
                    break
                }
            }
            if isComplete! == true {
                let alertVC = UIAlertController(title: "恭喜过关", message: "牛人，留下您的大名", preferredStyle: UIAlertControllerStyle.Alert)
                alertVC.addTextFieldWithConfigurationHandler({ (txtField) in
                    txtField.delegate = self
                })
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (action) in
                    self.saveRecorder()
                    self.dismissViewControllerAnimated(false, completion: nil)
                })
                let restartAction = UIAlertAction(title: "继续", style: UIAlertActionStyle.Default, handler: { (action) in
                    self.saveRecorder()
                    self.clickRestartButton(UIButton())
                    alertVC.dismissViewControllerAnimated(false, completion: nil)
                })
                alertVC.addAction(cancelAction)
                alertVC.addAction(restartAction)
                presentViewController(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
         name = textField.text
    }
    
    func saveRecorder() {
        
        print(self.name!, self.time!, self.stepValue!)
        RecordDataTool.shareRecord().queue .inDatabase { (db) in
            do {
                try db.executeUpdate("INSERT INTO Record_score (name, time, step) VALUES (?, ?, ?)", values: [self.name!, self.time!, self.stepValue!])
            } catch {
                print("error = \(error)")
            }
        }
    }
    
    func changeArrayOrder(array: [UIImage]) -> [UIImage] {
        
        var tempArray = imageArray
        tempArray.removeLast()
        for _ in 0..<100 {
            let num = Int(arc4random_uniform(UInt32(tempArray.count - 1)))
            let image = tempArray[num]
            tempArray.removeAtIndex(num)
            tempArray.insert(image, atIndex: num/count > 1 ? num - count : num + 1 )
        }
        return tempArray
    }
    
    func creatTime() {
        let minute = time! / 60
        let second = time! % 60
        timeLabel.text = String(format: "%02zd:%02zd", minute, second)
        time! += 1
    }
}
