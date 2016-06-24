//
//  ViewController.swift
//  SZChoosePictrue
//
//  Created by 吴三忠 on 16/6/21.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var count:Int? = 5
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = SZImage().clipImageWithImage(UIImage(named: "default.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectPictrue(sender: UIButton) {

        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.allowsEditing = true
        presentViewController(imageVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var image: UIImage
        if picker.allowsEditing  {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }
        else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        image = SZImage().clipImageWithImage(image)
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameVC: GameController = segue.destinationViewController as! GameController
        gameVC.count = count;
        gameVC.image = imageView.image
        gameVC.imageArray = SZImage().clipImageWithImage(imageView.image!, count: count!)
    }
    
    @IBAction func clickStrainDegreeButton(sender: UIButton) {
        
        let alertVC = UIAlertController(title: "选择游戏难度", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let actionEasy = UIAlertAction(title: "简单", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            self.count = 5
        }
        let actionNormal = UIAlertAction(title: "正常", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            self.count = 7
        }
        let actionHard = UIAlertAction(title: "困难", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            self.count = 9
        }
        alertVC.addAction(actionEasy)
        alertVC.addAction(actionNormal)
        alertVC.addAction(actionHard)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
}

