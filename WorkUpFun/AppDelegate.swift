//
//  AppDelegate.swift
//  WorkUpFun
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Gaooof. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    let popover = NSPopover()
    
    var minute: UInt32 {
        let maxMinute: UInt32 = 25
        let minMinute: UInt32 = 15
        return arc4random_uniform(maxMinute - minMinute) + minMinute
    }
    
    var second: UInt32 {
        let maxSecond: UInt32 = 59
        let minSecond: UInt32 = 0
        return arc4random_uniform(maxSecond - minSecond) + minSecond
    }
    
    /// 启动
    func applicationDidFinishLaunching(_ aNotification: Notification) {

       initSubViews()
        
        
        let workTime1 = "08:\(minute):\(second)"
        let workTime2 = "13:\(minute):\(second)"
        let workTime3 = "18:\(minute):\(second)"
        print("\(workTime1)===\(workTime2),\(workTime3)")
        startTimeStr(startTimeStr: workTime1)
        startTimeStr(startTimeStr: workTime2)
        startTimeStr(startTimeStr: workTime3)
        
        
        
    }

    /// 退出
    func applicationWillTerminate(_ aNotification: Notification) {
        Tool.shareTool.group.notify(queue: DispatchQueue.main) {
            print("complete!")
        }

        Tool.shareTool.seeWork { [weak self](result) in
            if result != WorkResult.WorkResultNone {
                self?.showAlert()
            }
        }
    }

    func initSubViews() {
        if let button = statusItem.button{
            button.image = NSImage(named: "remove-24")
            button.action = #selector(AppDelegate.togglePopover)
        }
        
        let  contentVC = QuotesViewController(nibName: "QuotesViewController", bundle: nil)
        popover.contentSize = NSSize(width: 126, height: 280)
        contentVC?.btnDidClick(btnBlock: { (isShowWrire) in
            self.popover.contentSize = NSSize(width:(isShowWrire ? 480 : 126), height: 280)
        })
        popover.contentViewController = contentVC
    }
    
    func startTimeStr(startTimeStr:String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let workDate = formatter.date(from: startTimeStr)
        var nowDate = Date()
        let nowStr = formatter.string(from: nowDate)
        nowDate = formatter.date(from: nowStr)!
        print(nowDate)
        let time = workDate?.timeIntervalSince(nowDate)
        print(time)
        if time!<0 { return }
        DispatchQueue.global().asyncAfter(deadline: .now()+time!) {
            print("呵呵呵")
        }
    }
    
    func showPopover(sender:AnyObject?){
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showAlert() {
        let alert = NSAlert()
        alert.messageText = "好像事情没有做？"
        alert.addButton(withTitle: "呵呵哒")
        alert.addButton(withTitle: "去看看")
        alert.alertStyle = NSAlertStyle.warning
        let result = alert.runModal()
        if result == NSAlertSecondButtonReturn{
            let url = NSURL(string:workUrl)!
            let browserBundleIdentifier = "com.apple.Safari"
            NSWorkspace.shared().open([url as URL],
                                      withAppBundleIdentifier:browserBundleIdentifier,
                                      options:.andHide,
                                      additionalEventParamDescriptor:nil,
                                      launchIdentifiers:nil)
        }
        
    }

}

