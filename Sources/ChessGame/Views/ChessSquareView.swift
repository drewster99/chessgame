import Foundation
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
                let imageName = pieceImage(for: piece)
                
                Image(imageName, bundle: .module)
                    .resizable()
                    .foregroundColor(piece.isWhite ? .white : .black) // Set the color
                    .frame(width: 50, height: 50)
                    .shadow(radius: 1)
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
        let type = piece.type.rawValue
        let imageName = "\(color)_\(type)"
        return imageName
    }
}
