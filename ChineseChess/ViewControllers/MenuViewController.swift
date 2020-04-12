//
//  MenuViewController.swift
//  ChineseChess
//
//  Created by Pin Yiu on 7/4/2020.
//  Copyright © 2020 Pin Yiu. All rights reserved.
//

import Foundation
import UIKit

struct NotificationInfo {
    static let message = "message"
}

final class MenuViewController: UIViewController {
    var menuView: MenuView?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetStatus.shared.startMonitoring()
        
        if (menuView == nil) {
            menuView = MenuView(frame: view.bounds)
        }
        self.view.addSubview(self.menuView!)
        
        let notificationName = Notification.Name("menu")
        NotificationCenter.default.addObserver(self, selector: #selector(menuFunctions(noti:)), name: notificationName, object: nil)
        
        GameCenterHelper.helper.viewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func menuFunctions(noti: Notification) {
        if let userInfo = noti.userInfo, let message = userInfo[NotificationInfo.message] {
            let content = message as! String
            if (content == "local") {
                startLocalGame()
            }
            else if (content == "online") {
                startOnlineGame()
            } else if (content == "help") {
                startHelp()
            }
        }
    }
    
    func startOnlineGame() {
        let gameViewController = GameViewController()
        gameViewController.setGameMode(mode: 1)
        menuView?.gameModel?.isOnlineGame = true
        gameViewController.setGameModel(model: (menuView?.gameModel)!)
        self.navigationController?.pushViewController(gameViewController, animated: false)
    }
    
    func startLocalGame() {
        let gameViewController = GameViewController()
        gameViewController.setGameMode(mode: 0)
        self.navigationController?.pushViewController(gameViewController, animated: false)
    }
    
    func startHelp() {
        let helpViewController = HelpViewController()
        self.navigationController?.pushViewController(helpViewController, animated: false)
    }
}
