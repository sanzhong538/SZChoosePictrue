
//
//  RecordDataTool.swift
//  SZChoosePictrue
//
//  Created by 吴三忠 on 16/6/23.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

import Foundation

class RecordDataTool: NSObject {
    
    internal var queue: FMDatabaseQueue!
    
    
    class func shareRecord() -> RecordDataTool {
        
        struct Recorder {
            static var onceToken: dispatch_once_t = 0
            static var instance: RecordDataTool?
        }
        dispatch_once(&Recorder.onceToken) { 
            Recorder.instance = RecordDataTool()
        }
        return Recorder.instance!
    }
    
    override init() {
        super.init()
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/record.db")
        queue = FMDatabaseQueue(path: path)
        creatTable()
    }
    
    func creatTable() {
        
        queue.inTransaction { (db, rollback) in
            
            var result = false
            result = db.executeUpdate("CREATE TABLE IF NOT EXISTS Record_score (orderID integer PRIMARY KEY AUTOINCREMENT NOT NULL, name text, time integer, step integer);", withArgumentsInArray: nil)
            if result {
                print("数据库创建成功")
            }
            else {
                print("数据库创建失败")
            }
        }
    }
}
