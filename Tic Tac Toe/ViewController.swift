//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Alexus =P on 09.02.2022.
//

import UIKit

var pcMove = false
var gameEnded = false
var dumbPC = false
enum win {
    case firstRow, secondRow, thirdRow, firstColumn, secondColumn, thirdColumn, leftDiag, rightDiag, noWin, draw
}


class cell {
    var value: Int = 2
    let square: CGRect
    init(square: CGRect) {
        self.square=square
    }
}


class ViewController: UIViewController {

    var position: CGPoint = CGPoint(x: 0, y: 0)
    var fieldSize = CGFloat(0)
    var cellSize = CGFloat(0)
    var board: [cell] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var smartPcButton: UIButton!
    @IBOutlet weak var dumbPcButton: UIButton!
    
    @IBAction func restartButton(_ sender: Any) {
        resetBoard()
        drawBoard()
    }
    
    
    @IBAction func dumbPcButton(_ sender: Any) {
        dumbPC = true
        smartPcButton.setTitleColor(UIColor.systemGray, for: .normal)
        dumbPcButton.setTitleColor(UIColor.systemGreen, for: .normal)
    }
    
    @IBAction func smartPcButton(_ sender: Any) {
        dumbPC = false
        smartPcButton.setTitleColor(UIColor.systemGreen, for: .normal)
        dumbPcButton.setTitleColor(UIColor.systemGray, for: .normal)
    }
    
    
    @IBAction func pcMoveButton(_ sender: Any) {
        makePcMove()
    }
    
    //MARK: Сброс игрового поля
    func resetBoard() {
        gameEnded = false
        board.removeAll()
        for y in 0...2 {
            for x in 0...2 {
                let square = CGRect(x: cellSize * CGFloat(x), y: cellSize * CGFloat(y), width: cellSize, height: cellSize)
                board.append(cell(square: square))
            }
        }
        drawBoard()
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldSize = min(imageView.bounds.maxX, imageView.bounds.maxY)
        cellSize = CGFloat(fieldSize / 3)
        resetBoard()
    }
    
    //MARK: Перерисовка поля
    func drawBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: fieldSize, height: fieldSize))
        let img = renderer.image { context in
            context.cgContext.setLineWidth(2)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            //Рисуем клетки
            for i in board.indices {
                context.cgContext.setFillColor(UIColor.white.cgColor)
                context.cgContext.addRect(board[i].square)
                context.cgContext.drawPath(using: .fillStroke)
            }
            
            // Рисуем крестики-нолики
            for i in board.indices {
                switch board[i].value {
                case 1:
                    //Рисуем X
                    context.cgContext.setStrokeColor(UIColor.green.cgColor)
                    context.cgContext.setLineWidth(4)
                    context.cgContext.move(to: CGPoint(x: board[i].square.minX + 25, y: board[i].square.minY + 25))
                    context.cgContext.addLine(to: CGPoint(x: board[i].square.maxX - 25, y: board[i].square.maxY - 25))
                    context.cgContext.move(to: CGPoint(x: board[i].square.minX + 25, y: board[i].square.maxY - 25))
                    context.cgContext.addLine(to: CGPoint(x: board[i].square.maxX - 25, y: board[i].square.minY + 25))
                    context.cgContext.drawPath(using: .stroke)
                case 0:
                    //Рисуем O
                    context.cgContext.setLineWidth(4)
                    context.cgContext.setStrokeColor(UIColor.blue.cgColor)
                    context.cgContext.addEllipse(in: board[i].square.insetBy(dx: 25, dy: 25))
                    context.cgContext.drawPath(using: .stroke)
                default:
                    break
                }
            }
            
            //Зачеркивание при победе
            switch checkWin().result {
            case .firstColumn:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[0].square.midX, y: board[0].square.midY - 25))
                context.cgContext.addLine(to: CGPoint(x: board[6].square.midX, y: board[6].square.midY + 25))
                context.cgContext.drawPath(using: .stroke)
            case .secondColumn:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[1].square.midX, y: board[1].square.midY - 25))
                context.cgContext.addLine(to: CGPoint(x: board[7].square.midX, y: board[7].square.midY + 25))
                context.cgContext.drawPath(using: .stroke)
            case .thirdColumn:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[2].square.midX, y: board[2].square.midY - 25))
                context.cgContext.addLine(to: CGPoint(x: board[8].square.midX, y: board[8].square.midY + 25))
                context.cgContext.drawPath(using: .stroke)
            case .firstRow:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[0].square.midX - 25, y: board[0].square.midY))
                context.cgContext.addLine(to: CGPoint(x: board[2].square.midX + 25, y: board[2].square.midY))
                context.cgContext.drawPath(using: .stroke)
            case .secondRow:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[3].square.midX - 25, y: board[3].square.midY))
                context.cgContext.addLine(to: CGPoint(x: board[5].square.midX + 25, y: board[5].square.midY))
                context.cgContext.drawPath(using: .stroke)
            case .thirdRow:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[6].square.midX - 25, y: board[6].square.midY))
                context.cgContext.addLine(to: CGPoint(x: board[8].square.midX + 25, y: board[8].square.midY))
                context.cgContext.drawPath(using: .stroke)
            case .leftDiag:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[0].square.midX - 25, y: board[0].square.midY - 25))
                context.cgContext.addLine(to: CGPoint(x: board[8].square.midX + 25, y: board[8].square.midY + 25))
                context.cgContext.drawPath(using: .stroke)
            case .rightDiag:
                context.cgContext.setStrokeColor(UIColor.purple.cgColor)
                context.cgContext.setLineWidth(8)
                context.cgContext.move(to: CGPoint(x: board[6].square.midX - 25, y: board[6].square.midY + 25))
                context.cgContext.addLine(to: CGPoint(x: board[2].square.midX + 25, y: board[2].square.midY - 25))
                context.cgContext.drawPath(using: .stroke)
            case .draw:
                print("DRAW")
            default:
                break
            }
        }
        imageView.image = img
    }
    
    
    //MARK: Добавляем крестик или нолик на поле
    func drawSymbol (cell: Int) {
        if checkWin().result != .noWin {return}
        if board[cell].value == 2 {
            if pcMove {
                board[cell].value = 1
            } else {
                board[cell].value = 0
            }
        }
    }
    
    
    //MARK: Функция для сравнения трех клеток
    func equal3cells (a: Int, b: Int, c: Int) -> Bool {
        if board[a].value == board[b].value && board[a].value == board[c].value && board[a].value != 2 {
            return true
        } else {
            return false
        }
    }
    
    
    //MARK: Проверка на победу
    func checkWin () -> (result: win, winner: Int)  {
        var freeCells = 0
        for i in board.indices {
            if board[i].value == 2 {
                freeCells += 1
            }
        }
        
        if freeCells == 0 {
            gameEnded = true
            return (.draw, -1)
        }
        
        if equal3cells(a: 0, b: 1, c: 2) {
            gameEnded = true
            return (.firstRow, board[0].value)
        } else if equal3cells(a: 3, b: 4, c: 5) {
            gameEnded = true
            return (.secondRow, board[3].value)
        } else if equal3cells(a: 6, b: 7, c: 8) {
            gameEnded = true
            return (.thirdRow, board[6].value)
        } else if equal3cells(a: 0, b: 4, c: 8) {
            gameEnded = true
            return (.leftDiag, board[0].value)
        } else if equal3cells(a: 2, b: 4, c: 6) {
            gameEnded = true
            return (.rightDiag, board[2].value)
        } else if equal3cells(a: 0, b: 3, c: 6) {
            gameEnded = true
            return (.firstColumn, board[0].value)
        } else if equal3cells(a: 1, b: 4, c: 7) {
            gameEnded = true
            return (.secondColumn, board[1].value)
        } else if equal3cells(a: 2, b: 5, c: 8) {
            gameEnded = true
            return (.thirdColumn, board[2].value)
        } else {
            gameEnded = false
            return (.noWin, -2)
        }
    }
    
    
    //MARK: Отработка прикосновений
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pcMove && gameEnded == false {return}
        if let touch = touches.first {
            position = touch.location(in: imageView)
            position.y -= imageView.bounds.midY - fieldSize/2
            for i in board.indices {
                if board[i].square.contains(position) && board[i].value == 2 {
                    drawSymbol (cell: i)
                    drawBoard()
                    if !gameEnded { pcMove = true }
                }
            }
            
            if pcMove{
            // Можно добавить задержку к ходу компа
           // _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                makePcMove()
            }
        }
    }
    
    
    //MARK: Ход компа
    func makePcMove() {
        pcMove = true
        if dumbPC {
            //Это тупой комп
            var choice = Int.random(in: 0...8)
            while self.board[choice].value == 1 || self.board[choice].value == 0 {
                choice = Int.random(in: 0...8)
            }
            self.drawSymbol(cell: choice)
            self.drawBoard()
            pcMove = false
        
        } else {
        
            //А это умный комп
            drawSymbol(cell: bestMove())
            drawBoard()
            pcMove = false
        }
    }
    
    
    //MARK: Поиск лучшего хода для компа
    func bestMove () -> Int {
            var bestScore = -2000
            var move: Int?
            for i in board.indices {
                if board[i].value == 2 {
                    board[i].value = 1
                    let score = minimax (board: board, depth: 0, isMaximizing: false)
                    board[i].value = 2
                    if score > bestScore {
                        bestScore = score
                        move = i
                    }
                }
            }
            return move!
    }
    
    
    let scores = [-10, 10]
    
    
    //MARK: Алгоритм минимакс для поиска лучшего хода
    func minimax (board: [cell], depth: Int, isMaximizing: Bool) -> Int {
        let test = checkWin()
        if test.result != .noWin {
            if test.result == .draw {
                return 0
            } else {
                return scores[test.winner]
            }
        }
        if isMaximizing {
            var bestScore = -2000
            for i in board.indices {
                if board[i].value  == 2 {
                    board[i].value = 1
                    let score = minimax(board: board, depth: depth + 1, isMaximizing: false)
                    board[i].value = 2
                    bestScore = max(score, bestScore)
                }
            }
            return bestScore
        } else {
            var bestScore = 2000
            for i in board.indices {
                if board[i].value == 2 {
                    board[i].value = 0
                    let score = minimax(board: board, depth: depth + 1, isMaximizing: true)
                    board[i].value = 2
                    bestScore = min(score, bestScore)
                }
            }
            return bestScore
        }
    }
}

