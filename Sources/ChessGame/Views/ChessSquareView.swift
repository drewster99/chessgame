import SwiftUI

struct ChessSquareView: View {
    let position: Position
    let piece: ChessPiece?
    let isSelected: Bool
    @ObservedObject var game: ChessGame
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill((position.x + position.y) % 2 == 0 ? Color.white : Color.gray)
                .frame(width: 60, height: 60)
            
            if let piece = piece {
                Image(pieceImage(for: piece))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
        .overlay(
            Rectangle()
                .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
        )
        .onTapGesture {
            handleTap()
        }
    }
    
    private func handleTap() {
        print("🎯 Tapped square at position: (\(position.x), \(position.y))")
        print("👉 Current turn: \(game.isWhiteTurn ? "White" : "Black")")
        
        if let selectedPosition = game.selectedPiece {
            print("🎪 Moving piece from (\(selectedPosition.x), \(selectedPosition.y)) to (\(position.x), \(position.y))")
            if game.makeMove(from: selectedPosition, to: position) {
                print("✅ Move successful!")
                game.selectedPiece = nil
            } else {
                print("❌ Invalid move!")
            }
        } else {
            if let piece = piece {
                print("🎭 Piece at square: \(piece.isWhite ? "White" : "Black") \(piece.type)")
                if piece.isWhite == game.isWhiteTurn {
                    print("🎪 Selecting piece")
                    game.selectedPiece = position
                } else {
                    print("⛔️ Can't select opponent's piece on your turn")
                }
            } else {
                print("⬜️ Empty square")
            }
        }
    }
    
    private func pieceImage(for piece: ChessPiece) -> String {
        let color = piece.isWhite ? "white" : "black"
        switch piece.type {
        case .king: return "\(color)_king"
        case .queen: return "\(color)_queen"
        case .rook: return "\(color)_rook"
        case .bishop: return "\(color)_bishop"
        case .knight: return "\(color)_knight"
        case .pawn: return "\(color)_pawn"
        }
    }
}
