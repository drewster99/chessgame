import SwiftUI

struct ChessView: View {
    @StateObject private var game = ChessGame()
    
    var body: some View {
        VStack {
            Text(game.isCheck ? "Check!" : "")
                .font(.title)
                .foregroundColor(.red)
            
            Text(game.isCheckmate ? "Checkmate!" : "")
                .font(.title)
                .foregroundColor(.red)
            
            ForEach(0..<8) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8) { col in
                        ChessSquareView(
                            position: Position(x: col, y: row),
                            piece: game.board[row][col],
                            isSelected: game.selectedPiece == Position(x: col, y: row),
                            game: game
                        )
                    }
                }
            }
        }
        .padding()
    }
}

