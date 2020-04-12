//
//  MenuView.swift
//  ChineseChess
//
//  Created by Pin Yiu on 7/4/2020.
//  Copyright © 2020 Pin Yiu. All rights reserved.
//

import Foundation
import GameKit
import UIKit

class MenuView: UIView {
    var gameModel: GameModel?
    
    var localButton: UIButton?
    var onlineButton: UIButton?
    var helpButton: UIButton?
    
    var lastSize: CGSize?
    var localButtonRect: CGRect?
    var onlineButtonRect: CGRect?
    var helpButtonRect: CGRect?
    
    var accessibleElements: [Any]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initAccessibilityElements()
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.calculateSize(size: self.bounds.size)
        self.lastSize = CGSize(width: 0, height: 0)

        self.localButton = UIButton(type: UIButton.ButtonType.custom)
        self.localButton?.frame = localButtonRect!
        self.localButton?.setTitle(NSLocalizedString("local game", comment: ""), for: UIControl.State.normal)
        self.localButton?.layer.borderWidth = 5.0
        self.localButton?.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        self.localButton?.layer.cornerRadius = 25.0
        self.localButton?.layer.backgroundColor = UIColor(red: 227/255, green: 171/255, blue: 10/255, alpha: 1).cgColor
        self.localButton?.layer.masksToBounds = true
        self.localButton?.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        self.localButton?.setTitleColor(UIColor.black, for: .normal)
        self.localButton?.addTarget(self, action: #selector(MenuView.startLocalGame), for: .touchUpInside)
        self.localButton?.isEnabled = true
        
        self.onlineButton = UIButton(type: UIButton.ButtonType.custom)
        self.onlineButton?.frame = onlineButtonRect!
        self.onlineButton?.setTitle(NSLocalizedString("online game", comment: ""), for: UIControl.State.normal)
        self.onlineButton?.layer.borderWidth = 5.0
        self.onlineButton?.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        self.onlineButton?.layer.cornerRadius = 25.0
        self.onlineButton?.layer.backgroundColor = UIColor(red: 227/255, green: 171/255, blue: 10/255, alpha: 1).cgColor
        self.onlineButton?.layer.masksToBounds = true
        self.onlineButton?.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        self.onlineButton?.setTitleColor(UIColor.black, for: .normal)
        self.onlineButton?.addTarget(self, action: #selector(MenuView.startOnlineGame), for: .touchUpInside)
        self.onlineButton?.isEnabled = GameCenterHelper.isAuthenticated && NetStatus.shared.isConnected
        
        NetStatus.shared.netStatusChangeHandler = {
            DispatchQueue.main.async { [unowned self] in
                self.onlineButton?.isEnabled = GameCenterHelper.isAuthenticated && NetStatus.shared.isConnected
                self.setNeedsDisplay()
            }
        }
        
        self.helpButton = UIButton(type: UIButton.ButtonType.custom)
        self.helpButton?.frame = helpButtonRect!
        self.helpButton?.setTitle(NSLocalizedString("help", comment: ""), for: UIControl.State.normal)
        self.helpButton?.layer.borderWidth = 5.0
        self.helpButton?.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        self.helpButton?.layer.cornerRadius = 25.0
        self.helpButton?.layer.backgroundColor = UIColor(red: 227/255, green: 171/255, blue: 10/255, alpha: 1).cgColor
        self.helpButton?.layer.masksToBounds = true
        self.helpButton?.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        self.helpButton?.setTitleColor(UIColor.black, for: .normal)
        self.helpButton?.addTarget(self, action: #selector(MenuView.startHelp), for: .touchUpInside)
        self.helpButton?.isEnabled = true
        
        self.addSubview(localButton!)
        self.addSubview(onlineButton!)
        self.addSubview(helpButton!)
    }
    
    func calculateSize(size: CGSize) {
        var buttonHeight: CGFloat
        var buttonWidth: CGFloat
        
        buttonHeight = size.height / 12
        buttonWidth = size.width / 7 * 4
        
        localButtonRect = CGRect(x: (size.width - buttonWidth) / 2, y: (size.height - buttonHeight) / 2, width: buttonWidth, height: buttonHeight)
        onlineButtonRect = CGRect(x: (size.width - buttonWidth) / 2, y: (size.height - buttonHeight) / 2 + buttonHeight * 1.5, width: buttonWidth, height: buttonHeight)
        helpButtonRect = CGRect(x: (size.width - buttonWidth) / 2, y: (size.height - buttonHeight) / 2 + buttonHeight * 1.5 * 2, width: buttonWidth, height: buttonHeight)
    }
    
    override func draw(_ rect: CGRect) {
        let bgImage = UIImage(named: "img_chess_Menu_Background")
        bgImage?.draw(in: self.bounds)

        let titleImage = UIImage(named: "img_chess_Menu_Title")
        titleImage?.draw(in: CGRect(x: 0, y: self.bounds.height/9, width: self.bounds.width, height: self.bounds.height * 2/9))
        
        // calculate the device's size
        let size = self.bounds.size
        if (size.equalTo(self.lastSize!)) {
            self.lastSize = size
            self.calculateSize(size: size)
        }
        self.localButton?.frame = localButtonRect!
        self.onlineButton?.frame = onlineButtonRect!
        self.helpButton?.frame = helpButtonRect!
        
        self.setVoiceOver()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        GameCenterHelper.helper.currentMatch = nil
        
        // check whether user has logged in to GameCenter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authenticationChanged(_:)),
            name: .authenticationChanged,
            object: nil
        )
        
        // check whether user choose to play online
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(presentGame(_:)),
            name: .presentGame,
            object: nil
        )
    }
    
    @objc func startLocalGame() {
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("start the game", comment: "")))
        NotificationCenter.default.post(name: .menuMessage, object: nil, userInfo: [NotificationInfo.message: "local"])
    }
    
    @objc func startOnlineGame() {
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("start the game", comment: "")))
        GameCenterHelper.helper.presentMatchmaker()
    }
    
    @objc func startHelp() {
         NotificationCenter.default.post(name: .menuMessage, object: nil, userInfo: [NotificationInfo.message: "help"])
    }
    
    @objc private func authenticationChanged(_ notification: Notification) {
        onlineButton?.isEnabled = notification.object as? Bool ?? false && NetStatus.shared.isConnected
        self.setNeedsDisplay()
    }
    
    @objc private func presentGame(_ notification: Notification) {
        guard let match = notification.object as? GKTurnBasedMatch else {
            return
        }
        loadAndDisplay(match: match)
    }
    
    private func loadAndDisplay(match: GKTurnBasedMatch) {
        match.loadMatchData { data, error in
            let model: GameModel
            
            if let data = data {
                do {
                    model = try JSONDecoder().decode(GameModel.self, from: data)
                } catch {
                    model = GameModel()
                }
            } else {
                model = GameModel()
            }
            GameCenterHelper.helper.currentMatch = match
            self.gameModel = model
            NotificationCenter.default.post(name: .menuMessage, object: nil, userInfo: [NotificationInfo.message: "online"])
        }
    }
    
    func initAccessibilityElements() {
        if self.accessibleElements == nil {
            self.accessibleElements = []
            for _ in 0..<10 {
                let part = UIAccessibilityElement(accessibilityContainer: self)
                self.accessibleElements?.append(part)
            }
        }
    }
    
    func setVoiceOver() {
        // VoiceOver: Title logo
        let part = accessibleElements?[0] as! UIAccessibilityElement
        part.accessibilityFrame = UIAccessibility.convertToScreenCoordinates(CGRect(x: self.bounds.width/7, y: self.bounds.height/9, width: self.bounds.width * 5/7, height: self.bounds.height * 2/9), in: self)
        part.isAccessibilityElement = true
        part.accessibilityLabel = NSLocalizedString(String("Chinese Chess for visually impaired"), comment: "")
        
        // VoiceOver: local game button
        localButton?.isAccessibilityElement = true
        localButton?.accessibilityLabel = NSLocalizedString(String("local game"), comment: "")
        accessibleElements![1] = localButton!
        
        // VoiceOver: onine game button
        onlineButton?.isAccessibilityElement = true
        if onlineButton!.isEnabled {
            onlineButton?.accessibilityLabel = NSLocalizedString(String("online game"), comment: "")
        } else {
            onlineButton?.accessibilityLabel = String(format: "%@,   %@", NSLocalizedString("online game", comment: ""), NSLocalizedString("No Internet connection. Make sure that Wi-Fi or mobile data is turned on that try again", comment: ""))
        }
        accessibleElements![2] = onlineButton!
        
        helpButton?.isAccessibilityElement = true
        helpButton?.accessibilityLabel = NSLocalizedString(String("help"), comment: "")
        accessibleElements![3] = helpButton!
        
        self.accessibilityElements = accessibleElements
    }
}

extension Notification.Name {
    static let menuMessage = Notification.Name("menu")
}
