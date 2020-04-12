//
//  GameModel.swift
//  ChineseChess
//
//  Created by Pin Yiu on 7/4/2020.
//  Copyright © 2020 Pin Yiu. All rights reserved.
//

import Foundation
import GameKit

struct Coord {
    var row: Int
    var column: Int
}

struct GameModel: Codable {
    var turn: Int
    var pieces: [Piece]
    var winner: Player?
    var chosenPiece: Piece?
    
    var records: [[Piece]] = []
    var moveRecords: [String] = []
    
    var isOnlineGame: Bool = false
    
    private(set) var isBlackTurn: Bool
    private var positions: [GridCoordinate] = []
    
    var currentPlayer: Player {
        return isBlackTurn ? .black : .red
    }
    
    var messageToDisplay: String {
        if winner != nil {
            if winner == GameModel.Player.black {
                return NSLocalizedString("Black Win", comment: "")
            }
            else if winner == GameModel.Player.red {
                return NSLocalizedString("Red Win", comment: "")
            }
        }
        
        if isBlackTurn {
            return NSLocalizedString("Black's Turn", comment: "")
        }
        else {
            return NSLocalizedString("Red's Turn", comment: "")
        }
    }
    
    init(isBlackTurn: Bool = false) {
        self.isBlackTurn = isBlackTurn
        
        turn = 0
        
        var gridCoordinate: GridCoordinate! = nil
        for row in 0..<10 {
            for column in 0..<9 {
                gridCoordinate = GridCoordinate(row: row, column: column, type: GameModel.getGridType(row: row, column: column), border: GameModel.getGridBorder(row: row, column: column), player: GameModel.getGridPlayer(row: row, column: column))
                positions.append(gridCoordinate)
            }
        }
        
        pieces = [
            
            Piece(player: Player.black, id: 1, coord: GridCoordinate(row: 0, column: 5, type: GridType.Square, border: GridBorder.Edge, player: Player.black), type: PieceType.Advisor),
            Piece(player: Player.black, id: 1, coord: GridCoordinate(row: 0, column: 6, type: GridType.Normal, border: GridBorder.Edge, player: Player.black), type: PieceType.Elephant),
            Piece(player: Player.black, id: 1, coord: GridCoordinate(row: 0, column: 7, type: GridType.Normal, border: GridBorder.Edge, player: Player.black), type: PieceType.Horse),
            Piece(player: Player.black, id: 1, coord: GridCoordinate(row: 0, column: 8, type: GridType.Normal, border: GridBorder.Corner, player: Player.black), type: PieceType.Chariot),
            Piece(player: Player.black, id: 2, coord: GridCoordinate(row: 0, column: 0, type: GridType.Normal, border: GridBorder.Corner, player: Player.black), type: PieceType.Chariot),
            Piece(player: Player.black, id: 2, coord: GridCoordinate(row: 0, column: 1, type: GridType.Normal, border: GridBorder.Edge, player: Player.black), type: PieceType.Horse),
            Piece(player: Player.black, id: 2, coord: GridCoordinate(row: 0, column: 2, type: GridType.Normal, border: GridBorder.Edge, player: Player.black), type: PieceType.Elephant),
            Piece(player: Player.black, id: 2, coord: GridCoordinate(row: 0, column: 3, type: GridType.Square, border: GridBorder.Edge, player: Player.black), type: PieceType.Advisor),
            Piece(player: Player.black, id: 0, coord: GridCoordinate(row: 0, column: 4, type: GridType.Square, border: GridBorder.Edge, player: Player.black), type: PieceType.General),
            Piece(player: Player.black, id: 1, coord: GridCoordinate(row: 2, column: 7, type: GridType.Normal, border: GridBorder.Normal, player: Player.black), type: PieceType.Cannon),
            Piece(player: Player.black, id: 2, coord: GridCoordinate(row: 2, column: 1, type: GridType.Normal, border: GridBorder.Normal, player: Player.black), type: PieceType.Cannon),
            Piece(player: Player.black, id: 1, coord: GridCoordinate(row: 3, column: 8, type: GridType.Normal, border: GridBorder.Edge, player: Player.black), type: PieceType.Solider),
            Piece(player: Player.black, id: 2, coord: GridCoordinate(row: 3, column: 6, type: GridType.Normal, border: GridBorder.Normal, player: Player.black), type: PieceType.Solider),
            Piece(player: Player.black, id: 3, coord: GridCoordinate(row: 3, column: 4, type: GridType.Normal, border: GridBorder.Normal, player: Player.black), type: PieceType.Solider),
            Piece(player: Player.black, id: 4, coord: GridCoordinate(row: 3, column: 2, type: GridType.Normal, border: GridBorder.Normal, player: Player.black), type: PieceType.Solider),
            Piece(player: Player.black, id: 5, coord: GridCoordinate(row: 3, column: 0, type: GridType.Normal, border: GridBorder.Edge, player: Player.black), type: PieceType.Solider),
            
            
            Piece(player: Player.red, id: 1, coord: GridCoordinate(row: 9, column: 0, type: GridType.Normal, border: GridBorder.Corner, player: Player.red), type: PieceType.Chariot),
            Piece(player: Player.red, id: 1, coord: GridCoordinate(row: 9, column: 1, type: GridType.Normal, border: GridBorder.Edge, player: Player.red), type: PieceType.Horse),
            Piece(player: Player.red, id: 1, coord: GridCoordinate(row: 9, column: 2, type: GridType.Normal, border: GridBorder.Edge, player: Player.red), type: PieceType.Elephant),
            Piece(player: Player.red, id: 1, coord: GridCoordinate(row: 9, column: 3, type: GridType.Square, border: GridBorder.Edge, player: Player.red), type: PieceType.Advisor),
            Piece(player: Player.red, id: 0, coord: GridCoordinate(row: 9, column: 4, type: GridType.Square, border: GridBorder.Edge, player: Player.red), type: PieceType.General),
            Piece(player: Player.red, id: 2, coord: GridCoordinate(row: 9, column: 5, type: GridType.Square, border: GridBorder.Edge, player: Player.red), type: PieceType.Advisor),
            Piece(player: Player.red, id: 2, coord: GridCoordinate(row: 9, column: 6, type: GridType.Normal, border: GridBorder.Edge, player: Player.red), type: PieceType.Elephant),
            Piece(player: Player.red, id: 2, coord: GridCoordinate(row: 9, column: 7, type: GridType.Normal, border: GridBorder.Edge, player: Player.red), type: PieceType.Horse),
            Piece(player: Player.red, id: 2, coord: GridCoordinate(row: 9, column: 8, type: GridType.Normal, border: GridBorder.Corner, player: Player.red), type: PieceType.Chariot),
            Piece(player: Player.red, id: 1, coord: GridCoordinate(row: 7, column: 1, type: GridType.Normal, border: GridBorder.Normal, player: Player.red), type: PieceType.Cannon),
            Piece(player: Player.red, id: 2, coord: GridCoordinate(row: 7, column: 7, type: GridType.Normal, border: GridBorder.Normal, player: Player.red), type: PieceType.Cannon),
            Piece(player: Player.red, id: 1, coord: GridCoordinate(row: 6, column: 0, type: GridType.Normal, border: GridBorder.Edge, player: Player.red), type: PieceType.Solider),
            Piece(player: Player.red, id: 2, coord: GridCoordinate(row: 6, column: 2, type: GridType.Normal, border: GridBorder.Normal, player: Player.red), type: PieceType.Solider),
            Piece(player: Player.red, id: 3, coord: GridCoordinate(row: 6, column: 4, type: GridType.Normal, border: GridBorder.Normal, player: Player.red), type: PieceType.Solider),
            Piece(player: Player.red, id: 4, coord: GridCoordinate(row: 6, column: 6, type: GridType.Normal, border: GridBorder.Normal, player: Player.red), type: PieceType.Solider),
            Piece(player: Player.red, id: 5, coord: GridCoordinate(row: 6, column: 8, type: GridType.Normal, border: GridBorder.Edge, player: Player.red), type: PieceType.Solider)
        ]
        
        records.append(pieces)
        moveRecords.append(NSLocalizedString("Will display last move here", comment: ""))
    }
    
    func checkAnyAvailblePiece(row: Int, column: Int) -> Bool {
        var result = false
        if !pieces.isEmpty {
            for index in 0..<pieces.count {
                let piece = pieces[index]
                if piece.coord.row == row && piece.coord.column == column && piece.player == currentPlayer {
                    result = true
                    break
                }
            }
        }
        return result
    }
    
    mutating func choosePiece(row: Int, column: Int) {
        chosenPiece = nil
        for index in 0..<pieces.count {
            let piece = pieces[index]
            if piece.coord.row == row && piece.coord.column == column {
                chosenPiece = piece
            }
        }
    }
    
    mutating func checkAction(row: Int, column: Int) -> Bool {
        if chosenPiece == nil {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: NSLocalizedString("please select a piece first", comment: ""))
            return false
        }
        
        var result = false
        let gridType = GameModel.getGridType(row: row, column: column)
        let gridPlayer = GameModel.getGridPlayer(row: row, column: column)
        
        let vertical = (chosenPiece?.coord.row)! - row
        let verticalValue = abs((chosenPiece?.coord.row)! - row)
        let horizontal = (chosenPiece?.coord.column)! - column
        let horizontalValue = abs((chosenPiece?.coord.column)! - column)
        let differenceRow = row - chosenPiece!.coord.row
        let differenceColumn = column - chosenPiece!.coord.column
        
        if (verticalValue == 0 && horizontalValue == 0) || (checkAnyAvailblePiece(row: row, column: column)) {
            return false
        } else if (verticalValue == 1 && horizontalValue == 0) || (verticalValue == 0 && horizontalValue == 1) {
            if chosenPiece?.type == GameModel.PieceType.Solider {
                if chosenPiece?.player == gridPlayer {
                    if (chosenPiece?.player == GameModel.Player.black && vertical == -1) || (chosenPiece?.player == GameModel.Player.red && vertical == 1) {
                        result = true
                    } else {
                        result = false
                    }
                } else {
                    if (chosenPiece?.player == GameModel.Player.black && vertical == -1) || (chosenPiece?.player == GameModel.Player.red && vertical == 1) || horizontalValue == 1 {
                        result = true
                    } else {
                        result = false
                    }
                }
            } else if chosenPiece?.type == GameModel.PieceType.Chariot {
                result = true
            } else if chosenPiece?.type == GameModel.PieceType.Cannon && !checkAnyPiece(row: row, column: column) {
                result = true
            } else if chosenPiece?.type == GameModel.PieceType.General && gridType == .Square {
                result = true
            } else {
                result = false
            }
        } else if (verticalValue > 1 && horizontalValue == 0) && chosenPiece?.type == GameModel.PieceType.General {
            result = true
            for index in 0..<pieces.count {
                let piece = pieces[index]
                if piece.coord.row == row && piece.coord.column == column && piece.type != GameModel.PieceType.General {
                    result = false
                    break
                }
                if piece.coord.column == column && piece.type != GameModel.PieceType.General {
                    if (currentPlayer == .red && (piece.coord.row < (chosenPiece?.coord.row)! && piece.coord.row > row)) || (currentPlayer == .black && (piece.coord.row > (chosenPiece?.coord.row)! && piece.coord.row < row)) {
                        result = false
                        break
                    }
                }
                if (!checkAnyPiece(row: row, column: column)) {
                    result = false
                    break
                }
            }
        } else if verticalValue == 1 && horizontalValue == 1 && chosenPiece?.type == GameModel.PieceType.Advisor {
            if gridType == .Square {
                 result = true
            } else {
                result = false
            }
        } else if ((verticalValue == 1 && horizontalValue == 2) || (verticalValue == 2 && horizontalValue == 1)) && chosenPiece?.type == GameModel.PieceType.Horse {
            result = true
            var vertDiffHorse = 0
            var horiDiffHorse = 0
            for index in 0..<pieces.count {
                let piece = pieces[index]
                if piece != chosenPiece {
                    vertDiffHorse = (chosenPiece?.coord.row)! - piece.coord.row
                    horiDiffHorse = (chosenPiece?.coord.column)! - piece.coord.column
                    print(vertDiffHorse)
                    print(horiDiffHorse)
                    print(verticalValue)
                    print(horizontalValue)
                    if (vertDiffHorse == 1 && horiDiffHorse == 0) {// <----- Piece above it ----->
                        if (vertical == 2 && (horizontal == 1 || horizontal == -1)) {
                            result = false
                            break
                        }
                    }
                    else if (vertDiffHorse == -1 && horiDiffHorse == 0) {// <----- Piece below it vertDiffHorse---->
                        if (vertical == -2 && (horizontal == 1 || horizontal == -1)) {
                            result = false
                            break
                        }
                    }
                    else if (vertDiffHorse == 0 && horiDiffHorse == 1) {
                        if ((vertical == 1 || vertical == -1) && horizontal == 2) {
                            result = false
                            break
                        }
                    }
                    else if (vertDiffHorse == 0 && horiDiffHorse == -1) {// <----- Piece one the right ----->
                        if ((vertical == 1 || vertical == -1) && horizontal == -2) {
                            result = false
                            break
                        }
                    }
                }
            }
        } else if (verticalValue == 2 && horizontalValue == 2) && chosenPiece?.type == GameModel.PieceType.Elephant {
            if chosenPiece?.player == gridPlayer {
                result = true
                var vertDiffElephant = 0
                var horiDiffElephant = 0
                for index in 0..<pieces.count {
                    let piece = pieces[index]
                    vertDiffElephant = (chosenPiece?.coord.row)! - piece.coord.row
                    horiDiffElephant = (chosenPiece?.coord.column)! - piece.coord.column
                    if piece != chosenPiece {
                        if(vertDiffElephant == 1 && horiDiffElephant == 1) {  // <----- top-left Piece ----->
                            if (vertical == 2 && horizontal == 2) {
                                result = false
                            }
                        }
                        else if(vertDiffElephant == 1 && horiDiffElephant == -1) {  // <----- top-right Piece ----->
                            if (vertical == 2 && horizontal == -2) {
                                result = false
                            }
                        }
                        else if(vertDiffElephant == -1 && horiDiffElephant == 1) {  // <----- below-right Piece ----->
                            if (vertical == -2 && horizontal == 2) {
                                result = false
                            }
                        }
                        else if(vertDiffElephant == -1 && horiDiffElephant == -1) {  // <----- top-right Piece ----->
                            if (vertical == -2 && horizontal == -2) {
                                result = false
                            }
                        }
                    }
                }
            } else {
                result = false
            }
        } else if ((verticalValue == 0 && horizontalValue > 1) || (verticalValue > 1 && horizontalValue == 0)) && (chosenPiece?.type == GameModel.PieceType.Chariot || chosenPiece?.type == GameModel.PieceType.Cannon) {
            result = true
            if chosenPiece?.type == GameModel.PieceType.Chariot {
                for index in 0..<pieces.count {
                    let piece = pieces[index]
                    if piece != chosenPiece {
                        if (piece.coord.column == column) {
                            if((piece.coord.row < chosenPiece!.coord.row) && (piece.coord.row > row) && differenceRow < 0) {
                                result = false
                            }
                            else if((piece.coord.row > chosenPiece!.coord.row) && (piece.coord.row < row) && differenceRow > 0) {
                                result = false
                            }
                        }
                        if (piece.coord.row == row) {
                            if((piece.coord.column < chosenPiece!.coord.column) && (piece.coord.column > column) && differenceColumn < 0) {
                                result = false
                            }
                            else if((piece.coord.column > chosenPiece!.coord.column) && (piece.coord.column < column) && differenceColumn > 0) {
                                result = false
                            }
                        }
                    }
                }
            } else if chosenPiece?.type == GameModel.PieceType.Cannon {
                var count = 0
                var pieceExist = false
                for index in 0..<pieces.count {
                    let piece = pieces[index]
                    if piece.coord.row == row && piece.coord.column == column && piece.player != chosenPiece!.player {
                        pieceExist = true
                    }
                    if piece != chosenPiece {
                        if (piece.coord.column == column) {
                            if((piece.coord.row < chosenPiece!.coord.row) && (piece.coord.row > row) && differenceRow < 0) {
                                count += 1
                            }
                            else if((piece.coord.row > chosenPiece!.coord.row) && (piece.coord.row < row) && differenceRow > 0) {
                                count += 1
                            }
                        }
                        if (piece.coord.row == row) {
                            if((piece.coord.column < chosenPiece!.coord.column) && (piece.coord.column > column) && differenceColumn < 0) {
                                count += 1
                            }
                            else if((piece.coord.column > chosenPiece!.coord.column) && (piece.coord.column < column) && differenceColumn > 0) {
                                count += 1
                            }
                        }
                    }
                }
                if pieceExist {
                    if count == 1 {
                        result = true
                    } else if count > 0 || count == 0 {
                        result = false
                    }
                } else {
                    if count > 0 {
                        result = false
                    }
                }
            }
        }
        
        if result {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@%@,%@ %@ %@", NSLocalizedString((chosenPiece!.player.rawValue)+" "+(chosenPiece!.type.rawValue), comment: ""), convertIdToSting(input: chosenPiece!.id), NSLocalizedString("Move", comment: ""),  NSLocalizedString(convertColumn(column: column), comment: ""), NSLocalizedString(convertRow(row: row), comment: "")))
        }
        return result
    }
    
    // In chinese chess, this function is not important, just an extension of checkAction
//    func checkChosenPieceIsMovable(chosenPiece: Piece, row: Int, column: Int) -> Bool {
//        var pieceExist = false
//        var compareResult = false
//
//        for index in 0..<pieces.count {
//            let piece = pieces[index]
//            if piece.coord.row == row && piece.coord.column == column && piece.player != chosenPiece.player {
//                pieceExist = true
//            }
//        }
//
//        if (!pieceExist) {
//            return true
//        }
//        else {
//            return compareResult
//        }
//    }
    
    mutating func checkWinner() {
        var redGeneral: Piece?
        var blackGeneral: Piece?
        
        for index in 0..<pieces.count {
            let piece = pieces[index]
            if piece.player == .red && piece.type == .General {
                redGeneral = piece
            } else if piece.player == .black && piece.type == .General {
                blackGeneral = piece
            }
            if redGeneral != nil && blackGeneral != nil {
                break
            }
        }
        
        if redGeneral!.eaten {
            self.winner = Player.black
        } else if blackGeneral!.eaten {
            self.winner = Player.red
        }
    }
    
    mutating func move(row: Int, column: Int) {
        isBlackTurn = !isBlackTurn
        let index = getPieceIndex(row: (chosenPiece?.coord.row)!, column: (chosenPiece?.coord.column)!)
        if (index != -1) {
            if (checkAnyPiece(row: row, column: column)) {
                let index = getPieceIndex(row: row, column: column)
                UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@%@ %@,     ,     ", NSLocalizedString((pieces[index].player.rawValue)+" "+(pieces[index].type.rawValue), comment: ""), convertIdToSting(input: pieces[index].id), NSLocalizedString("is captured", comment: "")))
                pieces[index].coord.row = -10
                pieces[index].coord.column = -10
            }
            pieces[index].coord.row = row
            pieces[index].coord.column = column
            pieces[index].coord.type = GameModel.getGridType(row: row, column: column)
            pieces[index].coord.border = GameModel.getGridBorder(row: row, column: column)
            
            moveRecords.append(String(format: "%@%@%@%@%@", NSLocalizedString((chosenPiece!.player.rawValue)+" "+(chosenPiece!.type.rawValue), comment: ""), convertIdToSting(input: chosenPiece!.id), NSLocalizedString("Move", comment: ""),  NSLocalizedString(convertColumn(column: column), comment: ""), NSLocalizedString(convertRow(row: row), comment: "")))
            
            chosenPiece = nil
            turn += 1
            records.append(pieces)
        }
    }
    
    mutating func undo(player: Player) {
        if turn == 0 {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("cant undo", comment: "")))
            return
        }
        if (turn >= 2) && (currentPlayer == player) && ((player == .black && turn%2 == 1) || (player == .red && turn%2 == 0)) {
            _ = records.popLast()
            _ = records.popLast()
            turn -= 2
            _ = moveRecords.popLast()
            _ = moveRecords.popLast()
            pieces = records.last!
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("undo successfully", comment: "")))
            return
        } else if ((turn > 1 && (currentPlayer != player)) || (player == .red && turn == 1)) {
            _ = records.popLast()
            turn -= 1
            pieces = records.last!
            isBlackTurn = !isBlackTurn
            _ = moveRecords.popLast()
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("undo successfully", comment: "")))
            return
        }
        
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: String(format: "%@,     ,     ,", NSLocalizedString("cant undo", comment: "")))
    }
    
    mutating func getAvailableMove() -> [GridIndex]? {
        if chosenPiece == nil {
            return nil
        }
        var moves: [GridIndex] = []
        for row in 0..<10 {
            for column in 0..<9 {
                if checkAction(row: row, column: column) {
                    moves.append(GridIndex(row: row, column: column))
                }
            }
        }
        
        return moves
    }

    
    func checkAnyPiece(row: Int, column: Int) ->Bool {
        for piece in pieces {
            if piece.coord.row == row && piece.coord.column == column {
                return true
            }
        }
        return false
    }
    
    func getPieceIndex(row: Int, column: Int) -> Int {
        var index = 0
        for piece in pieces {
            if piece.coord.row == row && piece.coord.column == column {
                return index
            }
            index += 1
        }
        return -1
    }
    
    static func getGridType(row: Int, column: Int) -> GridType {
        if (row == 0 || row == 1 || row == 2 || row == 7 || row == 8 || row == 9) && (column == 3 || column == 4 || column == 5) {
            return GridType.Square
        } else {
            return GridType.Normal
        }
    }
    
    static func getGridBorder(row: Int, column: Int) -> GridBorder {
        if (row == 0 && column == 0 || row == 0 && column == 8 || row == 9 && column == 0 || row == 9 && column == 8)
        {
            return GridBorder.Corner
        }
        else if (row == 0 || row == 9 || column == 0 || column == 8)
        {
            return GridBorder.Edge
        }
        else
        {
            return GridBorder.Normal
        }
    }
    
    static func getGridPlayer(row: Int, column: Int) -> Player {
        if row < 5 {
            return Player.black
        } else {
            return Player.red
        }
    }
    
    func getPosition(row: Int, column: Int) -> GridCoordinate? {
        for i in 0..<positions.count {
            if (positions[i].row == row && positions[i].column == column) {
                return positions[i]
            }
        }
        return nil
    }
    
    func convertRow(row: Int) -> String {
        let result = 10 - row
        return String(result)
    }
    
    func convertRowBack(row: String) -> Int {
        let temp = Int(row) ?? 0
        let result = 10 - temp
        return result
    }
    
    func convertColumn(column: Int) -> String {
        switch column {
        case 0:
            return "A"
        case 1:
            return "B"
        case 2:
            return "C"
        case 3:
            return "D"
        case 4:
            return "E"
        case 5:
            return "F"
        case 6:
            return "G"
        case 7:
            return "H"
        case 8:
            return "I"
        default:
            return ""
        }
    }
    
    func convertColumnBack(column: String) -> Int {
        switch column {
        case "A":
            return 0
        case "B":
            return 1
        case "C":
            return 2
        case "D":
            return 3
        case "E":
            return 4
        case "F":
            return 5
        case "G":
            return 6
        case "H":
            return 7
        case "I":
            return 8
        default:
            return -1
        }
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
    
}

extension GameModel {
    enum Player: String, Codable {
        case black = "Black"
        case red = "Red"
    }
    
//    enum State: Int, Codable {
//        case Placement
//        case movement
//    }
    
    enum GridType: String, Codable {
        case Normal = "Normal"
        case Square = "Square"
    }
    
    enum GridBorder: String, Codable {
        case Corner = "Corner"
        case Edge = "Edge"
        case Normal = ""
    }
    
    enum PieceType: String, Codable {
        case Chariot = "Chariot"
        case Horse = "Horse"
        case Elephant = "Elephant"
        case Advisor = "Advisor"
        case General = "General"
        case Cannon = "Cannon"
        case Solider = "Solider"
    }
    
    struct GridCoordinate: Codable, Equatable {
        var row, column: Int
        var type: GridType
        var border: GridBorder
        var player: Player
    }
    
    struct Piece: Codable, Equatable {
        let player: Player
        let id: Int
        var coord: GridCoordinate
        let type: PieceType
        var eaten: Bool {
            return (coord.column < 0 || coord.row < 0)
        }
        
    }
    
    
}
