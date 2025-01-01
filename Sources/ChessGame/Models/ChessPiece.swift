import Foundation

struct ChessPiece: Equatable {
    enum PieceType {
        case king, queen, rook, bishop, knight, pawn
    }
    
    let type: PieceType
    let isWhite: Bool
    var hasMoved = false
} 