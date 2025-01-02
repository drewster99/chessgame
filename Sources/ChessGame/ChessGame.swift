import SwiftUI
import AVFoundation

class ChessGame: ObservableObject {
    @Published var board: [[ChessPiece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    @Published var selectedPiece: Position?
    @Published var isCheck = false
    @Published var isCheckmate = false
    @Published var isWhiteTurn = true
    
    private var moveSound: AVAudioPlayer?
    private var gameOverSound: AVAudioPlayer?
    
    init() {

print("Bundle.main = \(Bundle.main)")
print("Bundle.module = \(Bundle.module)")
print("Bundle.module resource path: \(Bundle.module.resourcePath ?? "Not found")")

        setupBoard()
        setupSounds()
    }
    
    private func setupSounds() {
        if let moveURL = Bundle.main.url(forResource: "move", withExtension: "wav") {
            moveSound = try? AVAudioPlayer(contentsOf: moveURL)
        }
        if let gameOverURL = Bundle.main.url(forResource: "gameover", withExtension: "wav") {
            gameOverSound = try? AVAudioPlayer(contentsOf: gameOverURL)
        }
    }
    
    private func setupBoard() {
        // Set up pawns
        for x in 0..<8 {
            board[1][x] = ChessPiece(type: .pawn, isWhite: true)
            board[6][x] = ChessPiece(type: .pawn, isWhite: false)
        }
        
        // Set up other pieces
        let backRowPieces: [ChessPiece.PieceType] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]
        for x in 0..<8 {
            board[0][x] = ChessPiece(type: backRowPieces[x], isWhite: true)
            board[7][x] = ChessPiece(type: backRowPieces[x], isWhite: false)
        }
    }
    
    func isValidMove(from: Position, to: Position) -> Bool {
        guard let piece = board[from.y][from.x] else { return false }
        
        // Basic validation
        if piece.isWhite != isWhiteTurn { return false }
        if let targetPiece = board[to.y][to.x], targetPiece.isWhite == piece.isWhite { return false }
        
        // Piece-specific move validation
        switch piece.type {
        case .pawn:
            let direction = piece.isWhite ? 1 : -1
            let dx = to.x - from.x
            let dy = to.y - from.y
            
            // Normal one square forward move
            if dx == 0 && dy == direction && board[to.y][to.x] == nil {
                return true
            }
            
            // Initial two square move
            if dx == 0 && ((piece.isWhite && from.y == 1 && dy == 2) || 
                (!piece.isWhite && from.y == 6 && dy == -2)) &&
                board[to.y][to.x] == nil && board[from.y + direction][from.x] == nil {
                return true
            }
            
            // Diagonal capture
            if abs(dx) == 1 && dy == direction && board[to.y][to.x] != nil {
                return true
            }
            
            return false
            
        case .rook:
            let dx = to.x - from.x
            let dy = to.y - from.y
            
            // Rook must move either horizontally or vertically
            if dx != 0 && dy != 0 {
                return false
            }
            
            // Check path for obstacles
            let xStep = dx == 0 ? 0 : dx > 0 ? 1 : -1
            let yStep = dy == 0 ? 0 : dy > 0 ? 1 : -1
            
            var x = from.x + xStep
            var y = from.y + yStep
            
            while x != to.x || y != to.y {
                if board[y][x] != nil {
                    return false
                }
                x += xStep
                y += yStep
            }
            
            return true
            
        case .knight:
            let dx = abs(to.x - from.x)
            let dy = abs(to.y - from.y)
            
            // Knight moves in L-shape: 2 squares in one direction and 1 in the other
            return (dx == 2 && dy == 1) || (dx == 1 && dy == 2)
        case .bishop:
            // Bishop moves diagonally
            let dx = abs(to.x - from.x)
            let dy = abs(to.y - from.y)
            
            // Check if movement is diagonal
            if dx != dy {
                return false
            }
            
            // Check path for obstacles
            let xStep = to.x > from.x ? 1 : -1
            let yStep = to.y > from.y ? 1 : -1
            var x = from.x + xStep
            var y = from.y + yStep
            
            while x != to.x && y != to.y {
                if board[y][x] != nil {
                    return false
                }
                x += xStep
                y += yStep
            }
            
            return true
            
        case .queen:
            // Queen can move like both a rook and a bishop
            let dx = to.x - from.x
            let dy = to.y - from.y
            
            // Check diagonal movement like a bishop
            if abs(dx) == abs(dy) {
                let xStep = dx > 0 ? 1 : -1
                let yStep = dy > 0 ? 1 : -1
                var x = from.x + xStep
                var y = from.y + yStep
                
                while x != to.x && y != to.y {
                    if board[y][x] != nil {
                        return false
                    }
                    x += xStep
                    y += yStep
                }
                return true
            }
            
            // Check horizontal/vertical movement like a rook
            if dx != 0 && dy != 0 {
                return false
            }
            
            let xStep = dx == 0 ? 0 : dx > 0 ? 1 : -1
            let yStep = dy == 0 ? 0 : dy > 0 ? 1 : -1
            
            var x = from.x + xStep
            var y = from.y + yStep
            
            while x != to.x || y != to.y {
                if board[y][x] != nil {
                    return false
                }
                x += xStep
                y += yStep
            }
            return true
            
        case .king:
            // King can move one square in any direction
            let dx = abs(to.x - from.x)
            let dy = abs(to.y - from.y)
            return dx <= 1 && dy <= 1
        }
    }
    
    // Implementation of other piece-specific move validation methods would go here
    
    func makeMove(from: Position, to: Position) -> Bool {
        guard isValidMove(from: from, to: to) else { return false }
        
        let piece = board[from.y][from.x]
        board[to.y][to.x] = piece
        board[from.y][from.x] = nil
        
        moveSound?.play()
        
        if isCheckmate {
            gameOverSound?.play()
        }
        
        isWhiteTurn.toggle()
        
        if isWhiteTurn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeComputerMove()
            }
        }
        return true
    }
    
    private func makeComputerMove() {
        // Simple AI implementation
        var bestMove: (from: Position, to: Position)?
        var bestScore = Int.min
        
        for y in 0..<8 {
            for x in 0..<8 {
                guard let piece = board[y][x], piece.isWhite else { continue }
                
                for toY in 0..<8 {
                    for toX in 0..<8 {
                        let from = Position(x: x, y: y)
                        let to = Position(x: toX, y: toY)
                        
                        if isValidMove(from: from, to: to) {
                            let score = evaluateMove(from: from, to: to)
                            if score > bestScore {
                                bestScore = score
                                bestMove = (from, to)
                            }
                        }
                    }
                }
            }
        }
        
        if let move = bestMove {
            makeMove(from: move.from, to: move.to)
        }
    }
    
    private func evaluateMove(from: Position, to: Position) -> Int {
        // Simple evaluation function
        var score = 0
        
        if let targetPiece = board[to.y][to.x] {
            score += pieceValue(targetPiece.type)
        }
        
        // Add positional scoring here
        
        return score
    }
    
    private func pieceValue(_ type: ChessPiece.PieceType) -> Int {
        switch type {
        case .pawn: return 1
        case .knight, .bishop: return 3
        case .rook: return 5
        case .queen: return 9
        case .king: return 0
        }
    }
}
