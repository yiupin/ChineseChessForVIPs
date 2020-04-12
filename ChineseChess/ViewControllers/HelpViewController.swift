//
//  HelpViewController.swift
//  Jungle 2019
//
//  Created by Pin Yiu on 12/4/2020.
//  Copyright © 2020 CityU_Henry. All rights reserved.
//

import Foundation
import UIKit

final class HelpViewController: UIViewController {
    var helpView: HelpView?
    var returnBtn: UIButton?
    var titleLabel: UILabel?
    
    var accessibleElements: [Any]?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        commonInit()
        
        initAccessibilityElements()
    
        
    }
    
    func commonInit() {
        let screenSize = UIScreen.main.bounds.size
        self.view.backgroundColor = UIColor.white
        
        var buttonHeight: CGFloat
        var buttonWidth: CGFloat
        buttonHeight = screenSize.height / 10
        buttonWidth = buttonHeight
        
        if (helpView == nil) {
            helpView = HelpView(frame: CGRect(x: 0, y: 0+buttonHeight, width: screenSize.width, height: screenSize.height-buttonHeight))
        }
        self.view.addSubview(self.helpView!)
        
        let returnBtnImg = UIImage(named: "img_chess_return")
        self.returnBtn = UIButton(type: UIButton.ButtonType.custom)
        self.returnBtn?.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        self.returnBtn?.setImage(returnBtnImg, for: .normal)
        self.returnBtn?.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        self.returnBtn?.isEnabled = true
        self.view.addSubview(returnBtn!)
        
        self.titleLabel = UILabel()
        self.titleLabel?.frame = CGRect(x: (screenSize.width - screenSize.width) / 2, y: 0, width: screenSize.width, height: buttonHeight)
        self.titleLabel?.text = NSLocalizedString("help", comment: "")
        self.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 20)
        self.titleLabel?.textAlignment = .center
        self.view.addSubview(titleLabel!)
    }
    
    @objc func backToMenu() {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func initAccessibilityElements() {
        if (self.accessibleElements == nil) {
            self.accessibleElements = []
            for _ in 0..<20 {
                let part = UIAccessibilityElement(accessibilityContainer: self)
                self.accessibleElements?.append(part)
            }
        }
        self.setVoiceOver()
    }
    
    func setVoiceOver() {
        returnBtn?.isAccessibilityElement = true
        returnBtn?.accessibilityLabel = NSLocalizedString(String("back"), comment: "")
        accessibleElements![0] = returnBtn!
        
        titleLabel?.isAccessibilityElement = true
        titleLabel?.accessibilityLabel = NSLocalizedString(String("help"), comment: "")
        accessibleElements![1] = titleLabel!
        
        self.accessibilityElements = accessibleElements
    }
    
}
