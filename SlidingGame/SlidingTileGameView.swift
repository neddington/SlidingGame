//
//  ContentView.swift
//  SlidingGame
//
//  Created by Eddington, Nick on 11/1/23.
//
import SwiftUI

struct NumberPuzzleView: View {
    @State private var grid: [[Int]] = [[1, 2, 3], [4, 5, 6], [7, 0, 8]] // 0 represents the empty space
    let gridSize = 3
    @State private var showCongratulation = false
    @State private var winCount = UserDefaults.standard.integer(forKey: "winCount")
    @State private var cheatCount = UserDefaults.standard.integer(forKey: "cheatCount")


    var body: some View {
        VStack {
            Text("Wins: \(winCount)")
                .font(.title)
                .padding(.top, 20)
            
            ForEach(0..<gridSize, id: \.self) { row in
                HStack {
                    ForEach(0..<gridSize, id: \.self) { column in
                        Button(action: {
                            self.handleButtonTap(row: row, column: column)
                        }) {
                            Text("\(grid[row][column] == 0 ? "" : "\(grid[row][column])")")
                                .font(.largeTitle)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }

            Button(action: {
                self.cheat() // Renamed function
            }) {
                Text("Cheat")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if isGameComplete() {
                Button(action: {
                    resetGame()
                }) {
                    Text("Restart Game")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            winCount = 0
            cheatCount = 0
            UserDefaults.standard.set(winCount, forKey: "winCount")
            UserDefaults.standard.set(cheatCount, forKey: "cheatCount")
            shufflePuzzle()
        }
        .alert(isPresented: $showCongratulation) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("You solved the puzzle."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func handleButtonTap(row: Int, column: Int) {
        let emptyRow = self.findEmptySpace().row
        let emptyColumn = self.findEmptySpace().column

        if (row == emptyRow && abs(column - emptyColumn) == 1) ||
            (column == emptyColumn && abs(row - emptyRow) == 1) {
            withAnimation {
                grid[emptyRow][emptyColumn] = grid[row][column]
                grid[row][column] = 0
            }

            if isGameComplete() {
                showCongratulation = true
                winCount += 1
                UserDefaults.standard.set(winCount, forKey: "winCount")
            }
        }
    }

    func findEmptySpace() -> (row: Int, column: Int) {
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                if grid[row][column] == 0 {
                    return (row, column)
                }
            }
        }
        return (0, 0)
    }

    func isGameComplete() -> Bool {
        let targetGrid: [[Int]] = [[1, 2, 3], [4, 5, 6], [7, 8, 0]]
        return grid == targetGrid
    }

    func shufflePuzzle() {
        var numbers = Array(1...8)
        numbers.shuffle()
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                if row == gridSize - 1 && column == gridSize - 1 {
                    grid[row][column] = 0
                } else {
                    grid[row][column] = numbers.removeFirst()
                }
            }
        }
    }

    func cheat() {
        cheatCount += 1
        UserDefaults.standard.set(cheatCount, forKey: "cheatCount")
        grid = [[1, 2, 3], [4, 5, 6], [0, 7, 8]]
    }

    func resetGame() {
        shufflePuzzle()
    }
}


struct NumberPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPuzzleView()
    }
}
