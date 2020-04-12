//
//  HelpView.swift
//  Jungle 2019
//
//  Created by Pin Yiu on 12/4/2020.
//  Copyright © 2020 CityU_Henry. All rights reserved.
//

import Foundation
import UIKit

class HelpView: UIView {
    
    var lastSize: CGSize?
    
    var myTextView: UITextView?
    
    
    var accessibleElements: [Any]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.initAccessibilityElements()
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.calculateSize(size: self.bounds.size)
        self.lastSize = CGSize(width: 0, height: 0)
        
        myTextView = UITextView(frame: frame)
        myTextView?.text = "語音指令例子\n\n1.查詢棋子位置\n紅馬嘅位置係邊度？\n\n2.選擇棋子\n選擇黑砲\n\n3.移動棋子\n紅兵移動到A6\n\n4.查詢棋子可以移動的位置\n先選擇棋子，然後語言輸入：可以移動嘅位置\n\n5.查詢棋子可以吃掉的棋子\n先選擇棋子，然後語言輸入：可以食咩棋子"
        myTextView?.font = .systemFont(ofSize: 20)
        myTextView?.isEditable = false
        self.addSubview(myTextView!)
        
    }
    
    func calculateSize(size: CGSize) {
        
    }
    
    override func draw(_ rect: CGRect) {
        // calculate the device's size
        let size = self.bounds.size
        if (size.equalTo(self.lastSize!)) {
            self.lastSize = size
            self.calculateSize(size: size)
        }
        
           
        self.setVoiceOver()
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
        
        
        self.accessibilityElements = accessibleElements
    }
}
