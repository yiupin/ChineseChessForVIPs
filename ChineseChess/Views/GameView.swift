//
//  GameView.swift
//  ChineseChess
//
//  Created by Pin Yiu on 8/4/2020.
//  Copyright © 2020 Pin Yiu. All rights reserved.
//

import Foundation
import UIKit

struct GridIndex {
    var row: Int
    var column: Int
}

class GameView: UIView {
    var model: GameModel
    
    // voiceover
    var accessibleElements: [Any]?
    
    var blockSize: CGSize?
    var gridRect: CGRect?
    
    var touchedBlockIndex: GridIndex?
    var pieceViews: [PieceView]?
    
    var chosenPiece: GameModel.Piece?
    var chosenOnePiece: Bool = false
    
    private var isSendingTurn = false

    init(frame: CGRect, model: GameModel) {
        self.model = model
        super.init(frame: frame)
        
        let chessboardHeight: CGFloat
        let chessboardWidth: CGFloat
        if (self.bounds.size.height/self.bounds.size.width < 12/7.1) {
            chessboardHeight = self.bounds.size.height / 12 * 10
            chessboardWidth = self.bounds.size.height / 12 * 9
        }
        else {
            chessboardWidth = self.bounds.size.width
            chessboardHeight = chessboardWidth / 9 * 10
        }
        let cellSize = chessboardWidth / 9
        
        self.blockSize = CGSize(width: cellSize, height: cellSize)
        self.gridRect = CGRect(x: (self.bounds.size.width - chessboardWidth) / 2, y: (self.bounds.size.height - chessboardHeight) / 2, width: chessboardWidth, height: chessboardHeight)
        
        let chessBoardView = UIImageView(frame: gridRect!)
        chessBoardView.image = UIImage(named: "layout_chessboard")
        self.addSubview(chessBoardView)
        self.sendSubviewToBack(chessBoardView)

        self.touchedBlockIndex?.row = NSNotFound
        self.touchedBlockIndex?.column = NSNotFound
        self.pieceViews = []
        self.setPiece()
        self.initAccessibilityElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        updateLastMove()
        self.setVoiceOver()
    }
    
    func blockFrameForPiece(piece: GameModel.Piece) -> CGRect {
        let startX = self.gridRect!.origin.x + (self.blockSize?.width)! * CGFloat(piece.coord.column)
        let startY = self.gridRect!.origin.y + (self.blockSize?.height)! * CGFloat(piece.coord.row)
        let blockFrame = CGRect(x: startX, y: startY, width: (self.blockSize?.width)!, height: (self.blockSize?.height)!)
        return blockFrame
    }
    
    func setBlockAtRowAndColumn(row: Int, column: Int) {
        if !model.checkAnyPiece(row: row, column: column) {
            let startX = self.gridRect!.origin.x + (self.blockSize?.width)! * CGFloat(column)
            let startY = self.gridRect!.origin.y + (self.blockSize?.height)! * CGFloat(row)
            let blockFrame = CGRect(x: startX, y: startY, width: (self.blockSize?.width)!, height: (self.blockSize?.height)!)
            let gridCell = self.model.getPosition(row: row, column: column)
            let part = self.accessibleElements![9 * row + column] as! UIAccessibilityElement
            part.isAccessibilityElement = true
            part.accessibilityLabel = String(format: "%@%@, %@, %@", NSLocalizedString(model.convertColumn(column: gridCell!.column), comment: ""), model.convertRow(row: gridCell!.row), NSLocalizedString((gridCell?.type.rawValue)!, comment: ""), NSLocalizedString((gridCell?.border.rawValue)!, comment: ""))
            part.accessibilityFrame = UIAccessibility.convertToScreenCoordinates(blockFrame, in: self)
        }
        else {
            let part = self.accessibleElements![9 * row + column] as! UIAccessibilityElement
            part.isAccessibilityElement = false
        }
    }
    
    func setPiece() {
        for piece in model.pieces {
            let blockFrame = self.blockFrameForPiece(piece: piece)
            let pieceView = PieceView(frame: blockFrame, piece: piece)
            pieceView.isAccessibilityElement = true
            pieceView.accessibilityLabel = String(format: "%@%@, %@ %@ %@, %@", NSLocalizedString((piece.player.rawValue)+" "+(piece.type.rawValue), comment: ""), convertIdToSting(input: piece.id), NSLocalizedString(model.convertColumn(column: piece.coord.column), comment: ""), NSLocalizedString(model.convertRow(row: piece.coord.row), comment: ""), NSLocalizedString((piece.coord.type.rawValue), comment: ""), NSLocalizedString((piece.coord.border.rawValue), comment: ""))
            pieceViews?.append(pieceView)
        }
        
        for pieceView in pieceViews! {
            self.addSubview(pieceView)
        }
    }
    
    func updateView() {
        var index = 0
        for piece in model.pieces {
            let blockFrame = self.blockFrameForPiece(piece: piece)
            UIView.animate(withDuration: 0.5, animations: {
                self.pieceViews![index].frame = blockFrame
            })
            self.pieceViews![index].piece = piece
            self.pieceViews![index].backgroundColor = nil
            self.pieceViews![index].accessibilityLabel = String(format: "%@%@, %@ %@ %@, %@", NSLocalizedString((piece.player.rawValue)+" "+(piece.type.rawValue), comment: ""), convertIdToSting(input: piece.id), NSLocalizedString(model.convertColumn(column: piece.coord.column), comment: ""), NSLocalizedString(model.convertRow(row: piece.coord.row), comment: ""), NSLocalizedString((piece.coord.type.rawValue), comment: ""), NSLocalizedString((piece.coord.border.rawValue), comment: ""))

            index += 1
        }
        self.setNeedsDisplay()
    }
    
    func convertIdToSting(input: Int) -> String {
        switch input {
        case 1:
            return "1"
        case 2:
            return "2"
        case 3:
            return "3"
        case 4:
            return "4"
        case 5:
            return "5"
        default:
            return ""
        }
    }
    
    private func returnToMenu() {
        NotificationCenter.default.post(name: .gameMessage, object: nil, userInfo: [NotificationInfo.message: "back to menu"])
    }
    
    private func updateLastMove() {
        NotificationCenter.default.post(name: .updateLastMoveMessage, object: nil, userInfo: [NotificationInfo.message: model.moveRecords.last!])
    }

    // touch events
    func touchedGridIndexFromTouches(touches: Set<UITouch>) -> GridIndex {
        var result = GridIndex(row: -1, column: -1)
        let touch = touches.first!
        var location = touch.location(in: self)
        
        if (self.gridRect!.contains(location)) {
            location.x -= gridRect!.origin.x
            location.y -= gridRect!.origin.y
            result.column = Int(location.x * 9.0 / (self.gridRect!.size.width))
            result.row = Int(location.y * 10.0 / (self.gridRect!.size.height))
        }
        return result
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchedBlockIndex = self.touchedGridIndexFromTouches(touches: touches)
          self.touchedGridIndex(gridIndex: self.touchedBlockIndex!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touched = self.touchedGridIndexFromTouches(touches: touches)
        if (touched.row != self.touchedBlockIndex?.row || touched.column != self.touchedBlockIndex?.column) {
            self.touchedBlockIndex = touched
            self.touchedGridIndex(gridIndex: self.touchedBlockIndex!)
        }
    }
    
    func touchedGridIndex(gridIndex: GridIndex) {
        if model.isOnlineGame {
            guard !isSendingTurn && GameCenterHelper.helper.canTakeTurnForCurrentMatch else {
                return
            }
        }
        
        guard model.winner == nil else {
            return
        }
        
        if self.model.checkAnyPiece(row: gridIndex.row, column: gridIndex.column) && model.pieces[model.getPieceIndex(row: gridIndex.row, column: gridIndex.column)].player == model.currentPlayer {
            selectPiece(gridIndex: gridIndex)
        }
        else if chosenOnePiece {
            if self.model.checkAction(row: gridIndex.row, column: gridIndex.column) {
                // check move
                self.model.move(row: gridIndex.row, column: gridIndex.column)
                
                self.chosenPiece = nil
                self.chosenOnePiece = false
                
                if self.model.winner != nil {
                    
                }
                for v in self.subviews {
                    if v.restorationIdentifier == "move" {
                        v.removeFromSuperview()
                    }
                }
                updateView()
                
                model.checkWinner()
                
                if model.isOnlineGame {
                    isSendingTurn = true
                    if model.winner != nil {
                        GameCenterHelper.helper.win(model) { error in
                            defer {
                                self.isSendingTurn = false
                            }
                            if let e = error {
                                print("Error winning match: \(e.localizedDescription)")
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("finish game, we now return to game menu", comment: "")))
                                self.returnToMenu()
                            }
                        }
                    } else {
                        GameCenterHelper.helper.endTurn(model) { error in
                            defer {
                                self.isSendingTurn = false
                            }
                            if let e = error {
                                print("Error ending turn: \(e.localizedDescription)")
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("successful move, we now return to game menu", comment: "")))
                                self.returnToMenu()
                            }
                        }
                    }
                }
                else {
                    if model.winner != nil {
                        if model.winner == GameModel.Player.black {
                            NotificationCenter.default.post(name: .gameMessage, object: nil, userInfo: [NotificationInfo.message: "Black Win"])
                        }
                        else if model.winner == GameModel.Player.red {
                            NotificationCenter.default.post(name: .gameMessage, object: nil, userInfo: [NotificationInfo.message: "Red Win"])
                        }
                    }
                }
            } else {
                UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("cant move", comment: "")))
            }
        } else if self.model.checkAnyPiece(row: gridIndex.row, column: gridIndex.column) && model.pieces[model.getPieceIndex(row: gridIndex.row, column: gridIndex.column)].player != model.currentPlayer {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@%@,     ,     ,", NSLocalizedString("fail to select, now is", comment: ""),NSLocalizedString(model.currentPlayer.rawValue + "'s Turn", comment: "")))
        } else if !chosenOnePiece {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("please select a piece first", comment: "")))
        }
    }
    
    func selectPiece(gridIndex: GridIndex) {
            self.model.choosePiece(row: gridIndex.row, column: gridIndex.column)
            self.chosenOnePiece = true
            self.chosenPiece = self.model.chosenPiece
        for pieceView in pieceViews! {
            if pieceView.piece?.coord.row == chosenPiece?.coord.row && pieceView.piece?.coord.column == chosenPiece?.coord.column {
                pieceView.backgroundColor = UIColor.red
            } else {
                pieceView.backgroundColor = nil
            }
        }
        setAvailableMove()
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@%@, %@,     ,     ,", NSLocalizedString((chosenPiece?.player.rawValue)!+" "+(chosenPiece?.type.rawValue)!, comment: ""), convertIdToSting(input: (chosenPiece?.id)!), NSLocalizedString("is chosen", comment: "")))
    }
    
    func setAvailableMove() {
        for v in self.subviews {
            if v.restorationIdentifier == "move" {
                v.removeFromSuperview()
            }
        }
        setVoiceOver()
        let moves = model.getAvailableMove()
        if moves != nil {
            for move in moves! {
                let startX = self.gridRect!.origin.x + (self.blockSize?.width)! * CGFloat(move.column)
                let startY = self.gridRect!.origin.y + (self.blockSize?.height)! * CGFloat(move.row)
                let blockFrame = CGRect(x: startX, y: startY, width: (self.blockSize?.width)!, height: (self.blockSize?.height)!)
                let colorView = UIView(frame: blockFrame)
                colorView.restorationIdentifier = "move"
                if model.checkAnyPiece(row: move.row, column: move.column) {
                    for pieceView in pieceViews! {
                        let piece = pieceView.piece
                        if piece!.coord.row == move.row && piece!.coord.column == move.column {
                            pieceView.accessibilityLabel = String(format: "%@%@, %@ %@ %@, %@ %@", NSLocalizedString((piece!.player.rawValue)+" "+(piece!.type.rawValue), comment: ""), convertIdToSting(input: piece!.id), NSLocalizedString(model.convertColumn(column: piece!.coord.column), comment: ""), NSLocalizedString(model.convertRow(row: piece!.coord.row), comment: ""), NSLocalizedString((piece!.coord.type.rawValue), comment: ""), NSLocalizedString((piece!.coord.border.rawValue), comment: ""), NSLocalizedString("can capture", comment: ""))
                            break
                        }
                    }
                } else {
                    let gridCell = self.model.getPosition(row: move.row, column: move.column)
                    let part = self.accessibleElements![9 * move.row + move.column] as! UIAccessibilityElement
                    part.isAccessibilityElement = true
                    part.accessibilityLabel = String(format: "%@%@, %@, %@ %@", NSLocalizedString(model.convertColumn(column: gridCell!.column), comment: ""), model.convertRow(row: gridCell!.row), NSLocalizedString((gridCell?.type.rawValue)!, comment: ""), NSLocalizedString((gridCell?.border.rawValue)!, comment: ""), NSLocalizedString("can move", comment: ""))
                    part.accessibilityFrame = UIAccessibility.convertToScreenCoordinates(blockFrame, in: self)
                    self.accessibilityElements = accessibleElements
                }
                colorView.backgroundColor = UIColor.green
                colorView.alpha = 0.5
                self.addSubview(colorView)
            }
        }
    }

    // init accessibleElements
    func initAccessibilityElements() {
        if (self.accessibleElements == nil) {
            self.accessibleElements = []
            for _ in 0..<200 {
                let part = UIAccessibilityElement(accessibilityContainer: self)
                self.accessibleElements?.append(part)
            }
        }
    }
    
    func setVoiceOver() {
        // VoiceOVer: pieces
        accessibleElements![90] = pieceViews!
        
        // VoiceOver: blocks
        for row in 0..<10 {
            for column in 0..<9 {
                self.setBlockAtRowAndColumn(row: row, column: column)
            }
        }
        self.accessibilityElements = accessibleElements
    }
}

extension Notification.Name {
    static let gameMessage = Notification.Name("game")
    static let updateLastMoveMessage = Notification.Name("last move")
}
