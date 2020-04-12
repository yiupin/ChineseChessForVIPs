//
//  PieceView.swift
//  ChineseChess
//
//  Created by Pin Yiu on 8/4/2020.
//  Copyright © 2020 Pin Yiu. All rights reserved.
//

import Foundation
import UIKit

class PieceView: UIView {
    var piece: GameModel.Piece?
    
    init(frame: CGRect, piece: GameModel.Piece) {
        super.init(frame: frame)
        self.piece = piece
        self.setup()
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(2.0)
        
        let faceImage = UIImage(named: self.getPieceImageString()!)
        if ((faceImage) != nil) {
            let imageRect = rect.insetBy(dx: 0, dy: 0)
            faceImage?.draw(in: imageRect)
        }
    }
    
    func getPieceImageString() -> String? {
        if piece!.type == GameModel.PieceType.Advisor {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_ad1"
            } else {
                return "Xiangqi_al1"
            }
        }
        else if piece!.type == GameModel.PieceType.Cannon {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_cd1"
            } else {
                return "Xiangqi_cl1"
            }
        }
        else if piece!.type == GameModel.PieceType.Elephant {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_ed1"
            } else {
                return "Xiangqi_el1"
            }
        }
        else if piece!.type == GameModel.PieceType.General {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_gd1"
            } else {
                return "Xiangqi_gl1"
            }
        }
        else if piece!.type == GameModel.PieceType.Horse {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_hd1"
            } else {
                return "Xiangqi_hl1"
            }
        }
        else if piece!.type == GameModel.PieceType.Chariot {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_rd1"
            } else {
                return "Xiangqi_rl1"
            }
        }
        else if piece!.type == GameModel.PieceType.Solider {
            if piece?.player == GameModel.Player.black {
                return "Xiangqi_sd1"
            } else {
                return "Xiangqi_sl1"
            }
        }
        else {
            return nil
        }
    }

    func setup() {
        self.backgroundColor = nil
        self.isOpaque = false
        self.contentMode = UIView.ContentMode.redraw
    }
    
    override func awakeFromNib() {
        self.setup()
    }
}
