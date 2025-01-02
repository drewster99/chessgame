import Foundation

struct ChessPiece: Equatable {
    enum PieceType: String {
        case king = "king"
        case queen = "queen"
        case rook = "rook"
        case bishop = "bishop"
        case knight = "knight"
        case pawn = "pawn"
    }
    
    let type: PieceType
    let isWhite: Bool
    var hasMoved = false
} 